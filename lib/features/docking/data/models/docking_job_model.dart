import 'package:ailixir/core/entities/docking_score_entity.dart';
import 'package:ailixir/features/docking/domain/entities/docking_job_entity.dart';

class DockingScoreModel {
  final double affinity;
  final double inter;
  final double intra;
  final double torsions;
  final double unbound;

  const DockingScoreModel({
    required this.affinity,
    required this.inter,
    required this.intra,
    required this.torsions,
    required this.unbound,
  });

  factory DockingScoreModel.fromJson(Map<String, dynamic> json) {
    return DockingScoreModel(
      affinity: (json['affinity'] as num?)?.toDouble() ?? 0.0,
      inter: (json['inter'] as num?)?.toDouble() ?? 0.0,
      intra: (json['intra'] as num?)?.toDouble() ?? 0.0,
      torsions: (json['torsions'] as num?)?.toDouble() ?? 0.0,
      unbound: (json['unbound'] as num?)?.toDouble() ?? 0.0,
    );
  }

  DockingScoreEntity toEntity() {
    return DockingScoreEntity(
      affinity: affinity,
      inter: inter,
      intra: intra,
      torsions: torsions,
      unbound: unbound,
    );
  }
}

class DockingJobModel {
  final int jobId;
  final String status;
  final String? protein;
  final String? ligand;
  final List<DockingScoreModel> scores;
  final String? downloadUrl;
  final DateTime? createdAt;

  const DockingJobModel({
    required this.jobId,
    required this.status,
    this.protein,
    this.ligand,
    this.scores = const [],
    this.downloadUrl,
    this.createdAt,
  });

  factory DockingJobModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return DockingJobModel(
      jobId: json['job_id'] ?? json['id'] ?? 0,
      status: json['status'] as String? ?? 'unknown',
      protein: json['protein'] as String?,
      ligand: json['ligand'] as String?,
      scores:
          (json['scores'] as List<dynamic>?)
              ?.map(
                (e) => DockingScoreModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      downloadUrl: json['download_url'] as String?,
      createdAt: parseDate(json['created_at'] as String?),
    );
  }

  DockingJobEntity toEntity() {
    return DockingJobEntity(
      jobId: jobId,
      status: status,
      protein: protein,
      ligand: ligand,
      scores: scores.map((e) => e.toEntity()).toList(),
      downloadUrl: downloadUrl,
      createdAt: createdAt,
    );
  }
}
