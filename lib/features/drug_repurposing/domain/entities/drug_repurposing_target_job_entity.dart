import 'drug_repurposing_targets_response_entity.dart';

class DrugRepurposingTargetJobEntity {
  final int jobId;
  final String status;
  final DrugRepurposingTargetsResponseEntity? output;
  final DateTime? createdAt;

  const DrugRepurposingTargetJobEntity({
    required this.jobId,
    required this.status,
    this.output,
    this.createdAt,
  });
}
