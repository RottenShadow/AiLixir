import 'drug_repurposing_base_entity.dart';
import 'drug_repurposing_target_entity.dart';

/// Domain entity for the targets API response
class DrugRepurposingTargetsResponseEntity extends DrugRepurposingBaseEntity {
  final String diseaseId;
  final int totalTargets;
  final List<DrugRepurposingTargetEntity> targets;

  const DrugRepurposingTargetsResponseEntity({
    required super.diseaseName,
    required this.diseaseId,
    required this.totalTargets,
    required this.targets,
  });
}
