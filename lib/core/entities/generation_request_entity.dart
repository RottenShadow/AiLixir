class GenerationRequestEntity {
  final String targetProtein;
  final int numGenerations;
  final String? smilesSeed;
  final int? randomSeed;

  const GenerationRequestEntity({
    required this.targetProtein,
    required this.numGenerations,
    this.smilesSeed,
    this.randomSeed,
  });
}
