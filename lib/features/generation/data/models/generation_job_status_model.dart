import 'package:ailixir/features/generation/domain/entities/generation_job_entity.dart';

class GenerationJobStatusModel {
  final String jobId;
  final String status;
  final String? preset;
  final int? numMolecules;
  final int? returnTopK;
  final String? dockingMode;
  final int? dockTopK;
  final DateTime? createdAt;

  const GenerationJobStatusModel({
    required this.jobId,
    required this.status,
    this.preset,
    this.numMolecules,
    this.returnTopK,
    this.dockingMode,
    this.dockTopK,
    this.createdAt,
  });

  factory GenerationJobStatusModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return GenerationJobStatusModel(
      jobId: json['job_id'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      preset: json['preset'] as String?,
      numMolecules: (json['num_molecules'] as num?)?.toInt(),
      returnTopK: (json['return_top_k'] as num?)?.toInt(),
      dockingMode: json['docking_mode'] as String?,
      dockTopK: (json['dock_top_k'] as num?)?.toInt(),
      createdAt: parseDate(json['created_at'] as String?),
    );
  }

  GenerationJobEntity toEntity() {
    return GenerationJobEntity(
      jobId: jobId,
      status: status,
      preset: preset,
      numMolecules: numMolecules,
      returnTopK: returnTopK,
      dockingMode: dockingMode,
      dockTopK: dockTopK,
      createdAt: createdAt,
    );
  }
}
