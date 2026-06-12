import '../../domain/entities/drug_repurposing_screen_job_entity.dart';
import 'drug_repurposing_screen_response_model.dart';

class DrugRepurposingScreenJobModel {
  final int jobId;
  final String status;
  final DrugRepurposingScreenResponseModel? output;
  final DateTime? createdAt;

  const DrugRepurposingScreenJobModel({
    required this.jobId,
    required this.status,
    this.output,
    this.createdAt,
  });

  factory DrugRepurposingScreenJobModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    DrugRepurposingScreenResponseModel? parsedOutput;
    final outputRaw = data['output'];
    if (outputRaw != null && outputRaw is Map<String, dynamic>) {
      final wrapped = <String, dynamic>{
        'disease': outputRaw['disease'],
        'total_drugs': outputRaw['total_drugs'],
        'total_predictions': outputRaw['total_predictions'],
        'top_results': outputRaw['top_results'],
        'warnings': outputRaw['warnings'],
      };
      parsedOutput = DrugRepurposingScreenResponseModel.fromJson(wrapped);
    }

    return DrugRepurposingScreenJobModel(
      jobId: (data['job_id'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'unknown',
      output: parsedOutput,
      createdAt: parseDate(data['created_at'] as String?),
    );
  }

  DrugRepurposingScreenJobEntity toEntity() {
    return DrugRepurposingScreenJobEntity(
      jobId: jobId,
      status: status,
      output: output?.toEntity(),
      createdAt: createdAt,
    );
  }
}
