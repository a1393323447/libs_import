## LibsImport
Generate code for importing C functions and variables.

```C
// in dir: example/C

// file: hi.c
#include <stdio.h>

__declspec(dllexport) void hi() {
    printf("Hi Dart!\n");
}

// file: hello.c
#include <stdio.h>

__declspec(dllexport) void hello(int a, int b) {
    printf("hello: %d\n", a + b);
}
```
in Dart:
```dart
// in file: example/lib/c.dart
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
```
run:
```cmd
> pwd
example/

> cd C

> make build
gcc hello.c -shared -fPIC -o dlls/hello.dll
gcc hi.c -shared -fPIC -o dlls/hi.dll

> cd ../

> dart run build_runner build
[INFO] Generating build script completed, took 405ms
[INFO] Reading cached asset graph completed, took 84ms
[INFO] Checking for updates since last build completed, took 643ms
[INFO] Running build completed, took 19ms
[INFO] Caching finalized dependency graph completed, took 57ms
[INFO] Succeeded after 89ms with 0 outputs (0 actions)
```
Generate file:
```dart
// in file: example/lib/c.g.dart

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
```
run:
```text
> dart run
Building package executable... 
Built example:example.
hello: 3
Hi Dart!
```