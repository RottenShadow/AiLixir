class GenerationJobEntity {
  final String jobId;
  final String status;
  final String? preset;
  final int? numMolecules;
  final int? returnTopK;
  final String? dockingMode;
  final int? dockTopK;
  final DateTime? createdAt;

  const GenerationJobEntity({
    required this.jobId,
    required this.status,
    this.preset,
    this.numMolecules,
    this.returnTopK,
    this.dockingMode,
    this.dockTopK,
    this.createdAt,
  });
}
