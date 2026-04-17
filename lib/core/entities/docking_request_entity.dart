class DockingRequestEntity {
  final String? proteinFilePath;
  final String? proteinFileName;
  final String? ligandFilePath;
  final String? ligandFileName;
  // Grid box
  final double centerX;
  final double centerY;
  final double centerZ;
  final double sizeX;
  final double sizeY;
  final double sizeZ;
  // Advanced
  final double exhaustiveness;

  const DockingRequestEntity({
    this.proteinFilePath,
    this.proteinFileName,
    this.ligandFilePath,
    this.ligandFileName,
    required this.centerX,
    required this.centerY,
    required this.centerZ,
    required this.sizeX,
    required this.sizeY,
    required this.sizeZ,
    required this.exhaustiveness,
  });
}
