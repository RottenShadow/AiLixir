class GenerationRequestEntity {
  final String targetProtein;
  final int numMolecules;
  final int returnTopK;
  final String dockingMode;
  final int? dockTopK;

  const GenerationRequestEntity({
    required this.targetProtein,
    required this.numMolecules,
    required this.returnTopK,
    this.dockingMode = 'off',
    this.dockTopK,
  });
}
