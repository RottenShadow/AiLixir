class LigandEntity {
  final String id;
  final String candidateName;
  final String smiles;
  final DateTime generatedAt;

  const LigandEntity({
    required this.id,
    required this.candidateName,
    required this.smiles,
    required this.generatedAt,
  });

  static List<LigandEntity> createFakeData() {
    return [
      LigandEntity(
        id: '1',
        candidateName: 'Candidate #00812',
        smiles: 'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C',
        generatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LigandEntity(
        id: '2',
        candidateName: 'Candidate #00811',
        smiles: 'NC1=NC2=C(N=C(N2)C(=O)N)C(=O)N1',
        generatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LigandEntity(
        id: '3',
        candidateName: 'Candidate #00810',
        smiles: 'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O',
        generatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
  }
}
