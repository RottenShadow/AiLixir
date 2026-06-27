import 'package:ailixir/core/entities/docking_score_entity.dart';

class DockingJobEntity {
  final int jobId;
  final String status;
  final String? protein;
  final String? ligand;
  final List<DockingScoreEntity> scores;
  final String? downloadUrl;
  final DateTime? createdAt;

  const DockingJobEntity({
    required this.jobId,
    required this.status,
    this.protein,
    this.ligand,
    this.scores = const [],
    this.downloadUrl,
    this.createdAt,
  });
}
