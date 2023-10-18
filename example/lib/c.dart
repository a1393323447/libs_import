import 'dart:ffi';
import 'package:libs_import/libs_import.dart';

part 'c.g.dart';

typedef HelloNativeFn = Void Function(Int a, Int b);
typedef HelloFn = void Function(int a, int b);

typedef HiNativeFn = Void Function();
typedef HiFn = void Function();

@ImportAll([
  LibResource(dir: "C\\dlls", name: "hello", staticFunctions: {
    "hello": FFIType(native: HelloNativeFn, inDart: HelloFn)
  }),
  LibResource(
      dir: "C\\dlls",
      name: "hi",
      staticFunctions: {"hi": FFIType(native: HiNativeFn, inDart: HiFn)})
])
class CLibs {}
