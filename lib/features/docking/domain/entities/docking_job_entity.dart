class DockingJobInputsEntity {
  final String protein;
  final String? ligand;

  const DockingJobInputsEntity({
    required this.protein,
    this.ligand,
  });
}

class DockingJobResultsEntity {
  final List<double> vinaScores;
  final String? downloadUrl;

  const DockingJobResultsEntity({
    required this.vinaScores,
    this.downloadUrl,
  });
}

class DockingJobEntity {
  final int jobId;
  final String status;
  final DockingJobInputsEntity? inputs;
  final DockingJobResultsEntity? results;
  final DateTime? createdAt;

  const DockingJobEntity({
    required this.jobId,
    required this.status,
    this.inputs,
    this.results,
    this.createdAt,
  });
}
