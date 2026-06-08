import 'package:ailixir/core/entities/ligand_entity.dart';

class GenerationHistoryEntryModel {
  final String id;
  final String jobType;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const GenerationHistoryEntryModel({
    required this.id,
    required this.jobType,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory GenerationHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return GenerationHistoryEntryModel(
      id: json['id'] as String? ?? json['job_id'] as String? ?? '',
      jobType: json['job_type'] as String? ?? 'generation',
      status: json['status'] as String? ?? 'unknown',
      createdAt: parseDate(json['created_at'] as String?) ?? DateTime.now(),
      completedAt: parseDate(json['completed_at'] as String?),
    );
  }

  LigandEntity toEntity() {
    return LigandEntity(
      id: id,
      candidateName: jobType,
      smiles: '',
      generatedAt: createdAt,
    );
  }
}
