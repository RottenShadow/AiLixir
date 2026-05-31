class AdmetPredictionEntity {
  final String smiles;
  final double absorption;
  final double distribution;
  final double metabolism;
  final double excretion;
  final double toxicity;

  const AdmetPredictionEntity({
    required this.smiles,
    required this.absorption,
    required this.distribution,
    required this.metabolism,
    required this.excretion,
    required this.toxicity,
  });
}
