// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'c.dart';

// **************************************************************************
// ImportAllGenerator
// **************************************************************************

extension LibsImport on CLibs {
  // **************************************************************************
  // Lib Resource Generate from dynamic library `C\dlls\hello.dll`
  // **************************************************************************
  static final _helloLib = DynamicLibrary.open(r"C\dlls\hello.dll");
  void hello(
    int a,
    int b,
  ) {
    final helloFunction = _helloLib.lookupFunction<Void Function(Int, Int),
        void Function(int, int)>("hello");
    return helloFunction(
      a,
      b,
    );
  }

  // **************************************************************************
  // Lib Resource Generate from dynamic library `C\dlls\hi.dll`
  // **************************************************************************
  static final _hiLib = DynamicLibrary.open(r"C\dlls\hi.dll");
  void hi() {
    final hiFunction =
        _hiLib.lookupFunction<Void Function(), void Function()>("hi");
    return hiFunction();
  }
}
