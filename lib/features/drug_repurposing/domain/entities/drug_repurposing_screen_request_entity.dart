class DrugRepurposingScreenRequestEntity {
  final String diseaseName;
  final List<String> knownDrugs;
  final double minScore;
  final int topNTargets;

  const DrugRepurposingScreenRequestEntity({
    required this.diseaseName,
    required this.knownDrugs,
    this.minScore = 0.0,
    this.topNTargets = 10,
  });
}
