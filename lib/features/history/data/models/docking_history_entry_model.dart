import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/docking_score_entity.dart';

class DockingHistoryEntryModel {
  final int jobId;
  final String status;
  final String protein;
  final String? ligand;
  final List<DockingScoreEntity> scores;
  final String? downloadUrl;
  final DateTime createdAt;

  const DockingHistoryEntryModel({
    required this.jobId,
    required this.status,
    required this.protein,
    this.ligand,
    this.scores = const [],
    this.downloadUrl,
    required this.createdAt,
  });

  factory DockingHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return DockingHistoryEntryModel(
      jobId: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'unknown',
      protein: json['protein'] as String? ?? 'Unknown',
      ligand: json['ligand'] as String?,
      scores: (json['scores'] as List<dynamic>?)
              ?.map((e) => DockingScoreEntity(
                    affinity: (e['affinity'] as num?)?.toDouble() ?? 0.0,
                    inter: (e['inter'] as num?)?.toDouble() ?? 0.0,
                    intra: (e['intra'] as num?)?.toDouble() ?? 0.0,
                    torsions: (e['torsions'] as num?)?.toDouble() ?? 0.0,
                    unbound: (e['unbound'] as num?)?.toDouble() ?? 0.0,
                  ))
              .toList() ??
          [],
      downloadUrl: json['download_url'] as String?,
      createdAt: parseDate(json['created_at'] as String?) ?? DateTime.now(),
    );
  }

  DockingEntity toEntity() {
    final bestScore = scores.isNotEmpty
        ? scores.map((s) => s.affinity).reduce(
              (a, b) => a < b ? a : b,
            )
        : 0.0;

    return DockingEntity(
      id: jobId.toString(),
      targetId: protein,
      targetName: protein,
      jobId: 'JOB-$jobId',
      createdAt: createdAt,
      vinaScore: bestScore,
      scores: scores,
      downloadUrl: downloadUrl,
    );
  }
}
