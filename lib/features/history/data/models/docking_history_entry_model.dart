import 'dart:math';
import 'package:ailixir/core/entities/docking_entity.dart';

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
  final List<double> vinaScores;
  final String? downloadUrl;

  const DockingHistoryResultsModel({
    required this.vinaScores,
    this.downloadUrl,
  });

  factory DockingHistoryResultsModel.fromJson(Map<String, dynamic> json) {
    return DockingHistoryResultsModel(
      vinaScores: (json['vina_scores'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
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
    final vinaScore = results?.vinaScores.isNotEmpty == true
        ? results!.vinaScores.reduce(max)
        : 0.0;

    return DockingEntity(
      id: jobId.toString(),
      targetId: inputs.protein,
      targetName: inputs.protein,
      jobId: 'JOB-$jobId',
      createdAt: createdAt,
      vinaScore: vinaScore,
    );
  }
}
