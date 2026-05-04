class LigandDetailsEntity {
  final String id;
  final String candidateName;
  final String smiles;

  // Structure Validity
  final bool structureLoaded;
  final bool conformationLoaded;
  final bool sanitization;
  final bool allAtomsConnected;

  // Docking & Scoring
  final double vinaScore;
  final double qedScore;

  // MedChem Properties
  final bool validConnected;
  final double logP;
  final int rotBonds;
  final double tpsa;

  // REOS Filters
  final bool glaxo;
  final bool pains;
  final bool mlsmr;

  const LigandDetailsEntity({
    required this.id,
    required this.candidateName,
    required this.smiles,
    required this.structureLoaded,
    required this.conformationLoaded,
    required this.sanitization,
    required this.allAtomsConnected,
    required this.vinaScore,
    required this.qedScore,
    required this.validConnected,
    required this.logP,
    required this.rotBonds,
    required this.tpsa,
    required this.glaxo,
    required this.pains,
    required this.mlsmr,
  });

  static LigandDetailsEntity createFakeData(String ligandId) {
    // Simulate different quality ligands based on ID
    final isGoodLigand = ligandId == '1';

    return LigandDetailsEntity(
      id: ligandId,
      candidateName: 'Candidate #008${12 - int.parse(ligandId)}',
      smiles: ligandId == '1'
          ? 'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C'
          : ligandId == '2'
          ? 'NC1=NC2=C(N=C(N2)C(=O)N)C(=O)N1'
          : 'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O',
      structureLoaded: true,
      conformationLoaded: true,
      sanitization: true,
      allAtomsConnected: true,
      vinaScore: isGoodLigand ? -10.4 : -8.2,
      qedScore: isGoodLigand ? 0.84 : 0.62,
      validConnected: true,
      logP: isGoodLigand ? 2.14 : 3.87,
      rotBonds: isGoodLigand ? 4 : 8,
      tpsa: isGoodLigand ? 62.8 : 89.3,
      glaxo: true,
      pains: true,
      mlsmr: isGoodLigand,
    );
  }
}
