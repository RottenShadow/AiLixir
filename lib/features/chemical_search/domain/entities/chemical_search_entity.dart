class ChemicalSearchResultEntity {
  final String smiles;
  final double similarityScore;
  final int rank;
  final String? explanation;
  final String imageUrl;

  const ChemicalSearchResultEntity({
    required this.smiles,
    required this.similarityScore,
    required this.rank,
    this.imageUrl = '',
    this.explanation,
  });

  factory ChemicalSearchResultEntity.fromJson(
    Map<String, dynamic> json, {
    int? rank,
  }) {
    return ChemicalSearchResultEntity(
      smiles: json['smiles'] as String,
      similarityScore: (json['similarity_score'] as num).toDouble(),
      rank: rank ?? (json['rank'] as int? ?? 0),
      explanation: json['explanation'] as String?,
    );
  }

  // String get imageUrl =>
  //     'https://cactus.nci.nih.gov/chemical/structure/'
  //     '${Uri.encodeComponent(smiles)}/image';

  String get displayName => 'Compound_${smiles.hashCode.abs()}';

  String get cid => smiles.hashCode.abs().toString();
}

class ChemicalSearchResponseEntity {
  final List<ChemicalSearchResultEntity> results;
  final bool isFullRag;
  final Map<String, dynamic> metadata;

  const ChemicalSearchResponseEntity({
    required this.results,
    required this.isFullRag,
    required this.metadata,
  });
}
