import '../../domain/entities/drug_repurposing_target_job_entity.dart';
import 'drug_repurposing_targets_response_model.dart';

class DrugRepurposingTargetJobModel {
  final int jobId;
  final String status;
  final DrugRepurposingTargetsResponseModel? output;
  final DateTime? createdAt;

  const DrugRepurposingTargetJobModel({
    required this.jobId,
    required this.status,
    this.output,
    this.createdAt,
  });

  factory DrugRepurposingTargetJobModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    DrugRepurposingTargetsResponseModel? parsedOutput;
    final outputRaw = json['output'];
    if (outputRaw != null && outputRaw is Map<String, dynamic>) {
      final wrapped = <String, dynamic>{
        'disease': outputRaw['disease'],
        'total_targets': outputRaw['total_targets'],
        'targets': outputRaw['targets'],
      };
      parsedOutput = DrugRepurposingTargetsResponseModel.fromJson(wrapped);
    }

    return DrugRepurposingTargetJobModel(
      jobId:
          (json['job_id'] as num?)?.toInt() ??
          (json['id'] as num?)?.toInt() ??
          0,
      status: json['status'] as String? ?? 'unknown',
      output: parsedOutput,
      createdAt: parseDate(json['created_at'] as String?),
    );
  }

  DrugRepurposingTargetJobEntity toEntity() {
    return DrugRepurposingTargetJobEntity(
      jobId: jobId,
      status: status,
      output: output?.toEntity(),
      createdAt: createdAt,
    );
  }
}
