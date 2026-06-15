import '../../domain/entities/drug_repurposing_top_candidate_entity.dart';
import 'drug_repurposing_base_model.dart';

class DrugRepurposingTopCandidateModel extends DrugRepurposingBaseModel {
  final String drugName;
  final String smiles;
  final String targetSymbol;
  final String uniprotId;
  final double bindingScore;
  final int rank;
  final String status;

  const DrugRepurposingTopCandidateModel({
    required super.diseaseName,
    required this.drugName,
    required this.smiles,
    required this.targetSymbol,
    required this.uniprotId,
    required this.bindingScore,
    required this.rank,
    required this.status,
  });

  /// Creates a [DrugRepurposingTopCandidateModel] from JSON map.
  factory DrugRepurposingTopCandidateModel.fromJson(Map<String, dynamic> json) {
    return DrugRepurposingTopCandidateModel(
      diseaseName: (json['disease_name'] ?? json['disease'] ?? '') as String,
      drugName: (json['drug_name'] ?? '') as String,
      smiles: (json['smiles'] ?? '') as String,
      targetSymbol: (json['target_symbol'] ?? '') as String,
      uniprotId: (json['uniprot_id'] ?? '') as String,
      bindingScore: (json['binding_score'] as num?)?.toDouble() ?? 0.0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '') as String,
    );
  }

  /// Maps the model to its domain entity
  DrugRepurposingTopCandidateEntity toEntity() {
    return DrugRepurposingTopCandidateEntity(
      diseaseName: diseaseName,
      drugName: drugName,
      smiles: smiles,
      targetSymbol: targetSymbol,
      uniprotId: uniprotId,
      bindingScore: bindingScore,
      rank: rank,
      status: status,
    );
  }
}
