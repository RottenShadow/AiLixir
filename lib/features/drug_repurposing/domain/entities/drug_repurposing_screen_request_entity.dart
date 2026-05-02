class DrugRepurposingScreenRequestEntity {
  final String diseaseName;
  final List<String> knownDrugs;
  final List<String> extraSmiles;
  final int topK;

  const DrugRepurposingScreenRequestEntity({
    required this.diseaseName,
    required this.knownDrugs,
    required this.extraSmiles,
    required this.topK,
  });
}
