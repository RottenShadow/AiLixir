import 'drug_repurposing_base_entity.dart';

/// Represents a molecular target associated with a disease
class DrugRepurposingTargetEntity extends DrugRepurposingBaseEntity {
  final String symbol;
  final String name;
  final double associationScore;
  final String uniprotId;
  final List<String> pdbIds;

  const DrugRepurposingTargetEntity({
    required super.diseaseName,
    required this.symbol,
    required this.name,
    required this.associationScore,
    required this.uniprotId,
    required this.pdbIds,
  });
}
