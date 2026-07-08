class DockingScoreEntity {
  final double affinity;
  final double inter;
  final double intra;
  final double torsions;
  final double unbound;

  const DockingScoreEntity({
    required this.affinity,
    required this.inter,
    required this.intra,
    required this.torsions,
    required this.unbound,
  });
}
