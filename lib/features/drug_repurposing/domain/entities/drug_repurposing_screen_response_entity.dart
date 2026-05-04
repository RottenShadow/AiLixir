import 'drug_repurposing_base_entity.dart';
import 'drug_repurposing_top_candidate_entity.dart';

/// Domain entity for the complete screen response
class DrugRepurposingScreenResponseEntity extends DrugRepurposingBaseEntity {
  final int totalTargetsFound;
  final int totalDrugsScreened;
  final int totalPairsEvaluated;
  final List<DrugRepurposingTopCandidateEntity> topCandidates;
  final List<String> warnings;

  const DrugRepurposingScreenResponseEntity({
    required super.diseaseName,
    required this.totalTargetsFound,
    required this.totalDrugsScreened,
    required this.totalPairsEvaluated,
    required this.topCandidates,
    required this.warnings,
  });
}
