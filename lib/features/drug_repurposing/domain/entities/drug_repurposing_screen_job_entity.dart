import 'drug_repurposing_screen_response_entity.dart';

class DrugRepurposingScreenJobEntity {
  final int jobId;
  final String status;
  final DrugRepurposingScreenResponseEntity? output;
  final DateTime? createdAt;

  const DrugRepurposingScreenJobEntity({
    required this.jobId,
    required this.status,
    this.output,
    this.createdAt,
  });
}
