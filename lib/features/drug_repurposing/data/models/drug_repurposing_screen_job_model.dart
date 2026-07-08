import '../../domain/entities/drug_repurposing_screen_job_entity.dart';
import 'drug_repurposing_screen_request_model.dart';
import 'drug_repurposing_screen_response_model.dart';

class DrugRepurposingScreenJobModel {
  final int jobId;
  final String status;
  final DrugRepurposingScreenRequestModel? input;
  final DrugRepurposingScreenResponseModel? output;
  final DateTime? createdAt;

  const DrugRepurposingScreenJobModel({
    required this.jobId,
    required this.status,
    this.input,
    this.output,
    this.createdAt,
  });

  factory DrugRepurposingScreenJobModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    DrugRepurposingScreenRequestModel? parsedInput;
    final inputRaw = json['input'];
    if (inputRaw != null && inputRaw is Map<String, dynamic>) {
      parsedInput = DrugRepurposingScreenRequestModel.fromJson(inputRaw);
    }

    DrugRepurposingScreenResponseModel? parsedOutput;
    final outputRaw = json['output'];
    if (outputRaw != null && outputRaw is Map<String, dynamic>) {
      parsedOutput = DrugRepurposingScreenResponseModel.fromJson(outputRaw);
    }

    return DrugRepurposingScreenJobModel(
      jobId: (json['job_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'unknown',
      input: parsedInput,
      output: parsedOutput,
      createdAt: parseDate(json['created_at'] as String?),
    );
  }

  DrugRepurposingScreenJobEntity toEntity() {
    return DrugRepurposingScreenJobEntity(
      jobId: jobId,
      status: status,
      input: input,
      output: output?.toEntity(),
      createdAt: createdAt,
    );
  }
}
