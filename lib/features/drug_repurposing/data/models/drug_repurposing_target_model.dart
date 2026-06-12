import '../../domain/entities/drug_repurposing_target_entity.dart';
import 'drug_repurposing_base_model.dart';

class DrugRepurposingTargetModel extends DrugRepurposingBaseModel {
  final String symbol;
  final String name;
  final double associationScore;
  final String uniprotId;
  final List<String> pdbIds;

  const DrugRepurposingTargetModel({
    required super.diseaseName,
    required this.symbol,
    required this.name,
    required this.associationScore,
    required this.uniprotId,
    required this.pdbIds,
  });

  /// Creates a [DrugRepurposingTargetModel] from JSON map.
  factory DrugRepurposingTargetModel.fromJson(Map<String, dynamic> json) {
    return DrugRepurposingTargetModel(
      diseaseName: (json['disease_name'] ?? json['disease'] ?? '') as String,
      symbol: (json['symbol'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      associationScore: (json['score'] as num?)?.toDouble() ?? 0.0,
      uniprotId: (json['uniprot_id'] ?? '') as String,
      pdbIds: (json['pdb_ids'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  /// Maps the model to its domain entity
  DrugRepurposingTargetEntity toEntity() {
    return DrugRepurposingTargetEntity(
      diseaseName: diseaseName,
      symbol: symbol,
      name: name,
      associationScore: associationScore,
      uniprotId: uniprotId,
      pdbIds: pdbIds,
    );
  }
}
