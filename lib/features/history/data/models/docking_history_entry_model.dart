import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/docking_score_entity.dart';

class DockingHistoryInputsModel {
  final String protein;
  final String? ligand;

  const DockingHistoryInputsModel({required this.protein, this.ligand});

  factory DockingHistoryInputsModel.fromJson(Map<String, dynamic> json) {
    return DockingHistoryInputsModel(
      protein: json['protein'] as String? ?? 'Unknown',
      ligand: json['ligand'] as String?,
    );
  }
}

class DockingHistoryResultsModel {
  final List<DockingScoreEntity> scores;
  final String? downloadUrl;

  const DockingHistoryResultsModel({
    required this.scores,
    this.downloadUrl,
  });

  factory DockingHistoryResultsModel.fromJson(Map<String, dynamic> json) {
    return DockingHistoryResultsModel(
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
    );
  }
}

class DockingHistoryEntryModel {
  final int jobId;
  final String status;
  final DockingHistoryInputsModel inputs;
  final DockingHistoryResultsModel? results;
  final DateTime createdAt;

  const DockingHistoryEntryModel({
    required this.jobId,
    required this.status,
    required this.inputs,
    this.results,
    required this.createdAt,
  });

  factory DockingHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return DockingHistoryEntryModel(
      jobId: (json['job_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'unknown',
      inputs: DockingHistoryInputsModel.fromJson(
        (json['inputs'] as Map<String, dynamic>?) ?? {},
      ),
      results: json['results'] != null
          ? DockingHistoryResultsModel.fromJson(
              json['results'] as Map<String, dynamic>)
          : null,
      createdAt: parseDate(json['created_at'] as String?) ?? DateTime.now(),
    );
  }

  DockingEntity toEntity() {
    final scoreList = results?.scores ?? [];
    final bestScore = scoreList.isNotEmpty
        ? scoreList.map((s) => s.affinity).reduce(
              (a, b) => a < b ? a : b,
            )
        : 0.0;

    return DockingEntity(
      id: jobId.toString(),
      targetId: inputs.protein,
      targetName: inputs.protein,
      jobId: 'JOB-$jobId',
      createdAt: createdAt,
      vinaScore: bestScore,
      scores: scoreList,
    );
  }
}
