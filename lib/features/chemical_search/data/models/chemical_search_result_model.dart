import 'package:ailixir/features/chemical_search/domain/entities/chemical_search_entity.dart';

class ChemicalSearchResultModel {
  final int rank;
  final String smiles;
  final String name;
  final String cid;
  final double similarity;
  final String? explanation;
  final String imageUrl;

  const ChemicalSearchResultModel({
    required this.rank,
    required this.smiles,
    required this.name,
    required this.cid,
    required this.similarity,
    this.explanation,
    required this.imageUrl,
  });

  factory ChemicalSearchResultModel.fromJson(Map<String, dynamic> json) {
    return ChemicalSearchResultModel(
      rank: json['rank'] as int? ?? 0,
      smiles: json['smiles'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cid: json['cid'] as String? ?? '',
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0.0,
      explanation: json['explanation'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  ChemicalSearchResultEntity toEntity() {
    return ChemicalSearchResultEntity(
      smiles: smiles,
      similarityScore: similarity,
      rank: rank,
      explanation: explanation,
    );
  }
}
