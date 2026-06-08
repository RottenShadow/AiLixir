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

class DockingJobResultsModel {
  final List<double> vinaScores;
  final String? downloadUrl;

  const DockingJobResultsModel({
    required this.vinaScores,
    this.downloadUrl,
  });

  factory DockingJobResultsModel.fromJson(Map<String, dynamic> json) {
    return DockingJobResultsModel(
      vinaScores: (json['vina_scores'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      downloadUrl: json['download_url'] as String?,
    );
  }

  DockingJobResultsEntity toEntity() {
    return DockingJobResultsEntity(
      vinaScores: vinaScores,
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
