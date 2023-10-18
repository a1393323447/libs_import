class ImportAll {
  final List<LibResource> imports;
  const ImportAll(this.imports);
}

class FFIType {
  final Type native;
  final Type? inDart;
  const FFIType({required this.native, this.inDart});
}

class LibResource {
  final String dir;
  final String name;
  final Map<String, FFIType> staticFunctions;
  final Map<String, FFIType> staticVaribals;

  const LibResource({
    required this.dir,
    required this.name,
    this.staticFunctions = const {},
    this.staticVaribals = const {},
  });
}
