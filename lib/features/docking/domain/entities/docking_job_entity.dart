import 'package:ailixir/core/entities/docking_score_entity.dart';

class DockingJobInputsEntity {
  final String protein;
  final String? ligand;

  const DockingJobInputsEntity({
    required this.protein,
    this.ligand,
  });
}

class DockingJobResultsEntity {
  final List<DockingScoreEntity> scores;
  final String? downloadUrl;

  const DockingJobResultsEntity({
    required this.scores,
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
