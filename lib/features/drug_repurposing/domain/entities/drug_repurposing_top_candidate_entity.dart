import 'drug_repurposing_base_entity.dart';

/// Represents a top drug candidate for a specific disease
class DrugRepurposingTopCandidateEntity extends DrugRepurposingBaseEntity {
  final String drugName;
  final String smiles;
  final String targetSymbol;
  final String uniprotId;
  final double bindingScore;
  final int rank;
  final String status;

  const DrugRepurposingTopCandidateEntity({
    required super.diseaseName,
    required this.drugName,
    required this.smiles,
    required this.targetSymbol,
    required this.uniprotId,
    required this.bindingScore,
    required this.rank,
    required this.status,
  });
}
