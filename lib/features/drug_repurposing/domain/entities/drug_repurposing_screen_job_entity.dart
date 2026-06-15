import 'drug_repurposing_screen_request_entity.dart';
import 'drug_repurposing_screen_response_entity.dart';

class DrugRepurposingScreenJobEntity {
  final int jobId;
  final String status;
  final DrugRepurposingScreenRequestEntity? input;
  final DrugRepurposingScreenResponseEntity? output;
  final DateTime? createdAt;

  const DrugRepurposingScreenJobEntity({
    required this.jobId,
    required this.status,
    this.input,
    this.output,
    this.createdAt,
  });
}
