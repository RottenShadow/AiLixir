import 'package:ailixir/core/entities/ligand_details_entity.dart';

class LigandEntity {
  final String id;
  final String candidateName;
  final String smiles;
  final DateTime generatedAt;

  // Generation API fields (optional — populated from generation results)
  final int? rank;
  final bool? valid;
  final String? canonicalSmiles;
  final int? smilesState;
  final double? nll;
  final double? mw;
  final double? logp;
  final double? tpsa;
  final int? hbd;
  final int? hba;
  final int? rotBonds;
  final double? qed;
  final double? saScore;
  final double? predPAffMean;
  final double? dockingScore;
  final String? dockingStatus;

  const LigandEntity({
    required this.id,
    required this.candidateName,
    required this.smiles,
    required this.generatedAt,
    this.rank,
    this.valid,
    this.canonicalSmiles,
    this.smilesState,
    this.nll,
    this.mw,
    this.logp,
    this.tpsa,
    this.hbd,
    this.hba,
    this.rotBonds,
    this.qed,
    this.saScore,
    this.predPAffMean,
    this.dockingScore,
    this.dockingStatus,
  });

  LigandDetailsEntity toDetailsEntity() {
    return LigandDetailsEntity(
      id: id,
      candidateName: candidateName,
      smiles: canonicalSmiles ?? smiles,
      structureLoaded: true,
      conformationLoaded: true,
      sanitization: true,
      allAtomsConnected: true,
      vinaScore: dockingScore ?? -9.0,
      qedScore: qed ?? 0.5,
      validConnected: true,
      logP: logp ?? 2.0,
      rotBonds: rotBonds ?? 4,
      tpsa: tpsa ?? 60.0,
      glaxo: true,
      pains: true,
      mlsmr: true,
    );
  }

  static List<LigandEntity> createFakeData() {
    return [
      LigandEntity(
        id: '1',
        candidateName: 'Candidate #00812',
        smiles: 'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C',
        generatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        rank: 1,
        valid: true,
        canonicalSmiles: 'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C',
        smilesState: 1,
        nll: 8.24,
        mw: 427.51,
        logp: 3.16,
        tpsa: 87.14,
        hbd: 1,
        hba: 7,
        rotBonds: 6,
        qed: 0.506,
        saScore: 2.72,
        predPAffMean: 10.73,
        dockingScore: -8.91,
        dockingStatus: 'completed',
      ),
      LigandEntity(
        id: '2',
        candidateName: 'Candidate #00811',
        smiles: 'NC1=NC2=C(N=C(N2)C(=O)N)C(=O)N1',
        generatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        rank: 2,
        valid: true,
        canonicalSmiles: 'NC1=NC2=C(N=C(N2)C(=O)N)C(=O)N1',
        smilesState: 1,
        nll: 5.32,
        mw: 401.47,
        logp: 3.29,
        tpsa: 87.97,
        hbd: 2,
        hba: 6,
        rotBonds: 6,
        qed: 0.515,
        saScore: 2.40,
        predPAffMean: 9.78,
        dockingScore: -8.27,
        dockingStatus: 'completed',
      ),
      LigandEntity(
        id: '3',
        candidateName: 'Candidate #00810',
        smiles: 'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O',
        generatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        rank: 3,
        valid: true,
        canonicalSmiles: 'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O',
        smilesState: 1,
        nll: 5.95,
        mw: 426.52,
        logp: 3.77,
        tpsa: 74.25,
        hbd: 1,
        hba: 6,
        rotBonds: 5,
        qed: 0.524,
        saScore: 2.67,
        predPAffMean: 9.59,
        dockingScore: -10.25,
        dockingStatus: 'completed',
      ),
    ];
  }
}
