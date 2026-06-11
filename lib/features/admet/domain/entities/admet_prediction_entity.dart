class AdmetPredictionEntity {
  final String smiles;
  final double absorption;
  final double distribution;
  final double metabolism;
  final double excretion;
  final double toxicity;
  final String? source;
  final String? error;

  const AdmetPredictionEntity({
    required this.smiles,
    this.absorption = 0,
    this.distribution = 0,
    this.metabolism = 0,
    this.excretion = 0,
    this.toxicity = 0,
    this.source,
    this.error,
  });
}
