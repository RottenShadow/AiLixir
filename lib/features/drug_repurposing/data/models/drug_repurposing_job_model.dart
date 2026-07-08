import '../../domain/entities/drug_repurposing_job_entity.dart';

class DrugRepurposingJobModel {
  final int jobId;
  final String status;

  const DrugRepurposingJobModel({
    required this.jobId,
    required this.status,
  });

  factory DrugRepurposingJobModel.fromJson(Map<String, dynamic> json) {
    return DrugRepurposingJobModel(
      jobId: (json['job_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'unknown',
    );
  }

  DrugRepurposingJobEntity toEntity() {
    return DrugRepurposingJobEntity(
      jobId: jobId,
      status: status,
    );
  }
}
