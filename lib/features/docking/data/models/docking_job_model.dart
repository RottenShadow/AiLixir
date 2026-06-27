import 'package:ailixir/core/entities/docking_score_entity.dart';
import 'package:ailixir/features/docking/domain/entities/docking_job_entity.dart';

class DockingJobInputsModel {
  final String protein;
  final String? ligand;

  const DockingJobInputsModel({required this.protein, this.ligand});

  factory DockingJobInputsModel.fromJson(Map<String, dynamic> json) {
    return DockingJobInputsModel(
      protein: json['protein'] as String? ?? '',
      ligand: json['ligand'] as String?,
    );
  }

  DockingJobInputsEntity toEntity() {
    return DockingJobInputsEntity(protein: protein, ligand: ligand);
  }
}

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

class DockingJobResultsModel {
  final List<DockingScoreModel> scores;
  final String? downloadUrl;

  const DockingJobResultsModel({
    required this.scores,
    this.downloadUrl,
  });

  factory DockingJobResultsModel.fromJson(Map<String, dynamic> json) {
    return DockingJobResultsModel(
      scores: (json['scores'] as List<dynamic>?)
              ?.map((e) => DockingScoreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      downloadUrl: json['download_url'] as String?,
    );
  }

  DockingJobResultsEntity toEntity() {
    return DockingJobResultsEntity(
      scores: scores.map((e) => e.toEntity()).toList(),
      downloadUrl: downloadUrl,
    );
  }
}

class DockingJobModel {
  final int jobId;
  final String status;
  final DockingJobInputsModel? inputs;
  final DockingJobResultsModel? results;
  final DateTime? createdAt;

  const DockingJobModel({
    required this.jobId,
    required this.status,
    this.inputs,
    this.results,
    this.createdAt,
  });

  factory DockingJobModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return DockingJobModel(
      jobId: (json['job_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'unknown',
      inputs: json['inputs'] != null
          ? DockingJobInputsModel.fromJson(
              json['inputs'] as Map<String, dynamic>)
          : null,
      results: json['results'] != null
          ? DockingJobResultsModel.fromJson(
              json['results'] as Map<String, dynamic>)
          : null,
      createdAt: parseDate(json['created_at'] as String?),
    );
  }

  DockingJobEntity toEntity() {
    return DockingJobEntity(
      jobId: jobId,
      status: status,
      inputs: inputs?.toEntity(),
      results: results?.toEntity(),
      createdAt: createdAt,
    );
  }
}
