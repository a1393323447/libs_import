import 'package:libs_import/src/libs_import_gen.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart' as build;

build.Builder importAllBuilder(build.BuilderOptions options) =>
    SharedPartBuilder([ImportAllGenerator()], "import_all");
