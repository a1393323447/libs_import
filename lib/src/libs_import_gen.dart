import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:libs_import/libs_import.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart' as e;
import 'package:build/build.dart';
import 'package:path/path.dart' as path;

class ImportAllGenerator extends GeneratorForAnnotation<ImportAll> {
  @override
  String generateForAnnotatedElement(
      e.Element element, ConstantReader annotation, BuildStep buildStep) {
    assert(element.kind == e.ElementKind.CLASS,
        "@LibImport should be used on a class");
    final classElement = element as e.ClassElement;
    final libs = annotation.read("imports").listValue;
    var code = StringBuffer();
    for (final lib in libs) {
      code.write(genLibCode(lib));
    }
    return """
extension LibsImport on ${classElement.name} {
  $code
}
""";
  }

  static String genLibCode(DartObject lib) {
    final libDir = lib.getField("dir")!.toStringValue()!;
    final libName = lib.getField("name")!.toStringValue()!;
    final libVarName = "_${libName}Lib";
    String libPath = "";
    if (Platform.isLinux) {
      libPath = path.join(Directory.current.path, libDir, "$libName.so");
    } else if (Platform.isMacOS) {
      libPath = path.join(Directory.current.path, libDir, "$libName.dylib");
    } else if (Platform.isWindows) {
      libPath = path.join(libDir, "$libName.dll");
    }
    assert(
        libPath.isNotEmpty, "unsupport platform ${Platform.operatingSystem}");

    var code = StringBuffer();
    final staticFunctions = lib.getField("staticFunctions")!.toMapValue()!;
    for (final MapEntry(key: name, value: ffiType) in staticFunctions.entries) {
      code.write(
          genStaticFunction(libVarName, name!.toStringValue()!, ffiType!));
    }

    return """
  // **************************************************************************
  // Lib Resource Generate from dynamic library `$libPath`
  // **************************************************************************
  static final $libVarName = DynamicLibrary.open(r"$libPath");
  $code
""";
  }

  static String genStaticFunction(
      String libVarName, String name, DartObject ffiType) {
    final nativeType = ffiType.getField("native")!.toTypeValue()!;
    final inDartType = ffiType.getField("inDart")!.toTypeValue()!;
    assert(nativeType.isDartCoreFunction,
        "Native type of `$name` should be a function");
    assert(inDartType.isDartCoreFunction,
        "Dart type of `$name` should be a function");
    final nativeFunctionType = nativeType as FunctionType;
    final dartFunctionType =
        (inDartType as FunctionType?) ?? nativeFunctionType;
    final returnType = dartFunctionType.returnType;

    final params = dartFunctionType.parameters
        .fold("", (pramas, param) => "$pramas$param, ");
    final argNames = dartFunctionType.parameters
        .fold("", (argNames, arg) => "$argNames${arg.name}, ");
    return """
    $returnType $name($params) {
      final ${name}Function = $libVarName.lookupFunction<
        ${functionTypeToString(nativeFunctionType)}, 
        ${functionTypeToString(dartFunctionType)}
      >("$name");
      return ${name}Function($argNames);
    }
""";
  }

  static functionTypeToString(FunctionType function) {
    var str = function.toString();
    if (function.nullabilitySuffix != NullabilitySuffix.none) {
      str = str.substring(0, str.length - 1);
    }

    return str;
  }
}
