import 'package:ailixir/core/entities/ligand_entity.dart';

class LigandModel {
  final String smiles;
  final int smilesState;
  final double nll;
  final bool valid;
  final String canonicalSmiles;
  final double mw;
  final double logp;
  final double tpsa;
  final int hbd;
  final int hba;
  final int rotBonds;
  final double qed;
  final double saScore;
  final double predPAffMean;
  final double? dockingScore;
  final String? dockingStatus;
  final int rank;

  const LigandModel({
    required this.smiles,
    required this.smilesState,
    required this.nll,
    required this.valid,
    required this.canonicalSmiles,
    required this.mw,
    required this.logp,
    required this.tpsa,
    required this.hbd,
    required this.hba,
    required this.rotBonds,
    required this.qed,
    required this.saScore,
    required this.predPAffMean,
    this.dockingScore,
    this.dockingStatus,
    required this.rank,
  });

  factory LigandModel.fromJson(Map<String, dynamic> json) {
    return LigandModel(
      smiles: json['SMILES'] as String? ?? '',
      smilesState: (json['SMILES_state'] as num?)?.toInt() ?? 0,
      nll: (json['NLL'] as num?)?.toDouble() ?? 0,
      valid: json['valid'] as bool? ?? false,
      canonicalSmiles: json['canonical_smiles'] as String? ?? '',
      mw: (json['mw'] as num?)?.toDouble() ?? 0,
      logp: (json['logp'] as num?)?.toDouble() ?? 0,
      tpsa: (json['tpsa'] as num?)?.toDouble() ?? 0,
      hbd: (json['hbd'] as num?)?.toInt() ?? 0,
      hba: (json['hba'] as num?)?.toInt() ?? 0,
      rotBonds: (json['rot_bonds'] as num?)?.toInt() ?? 0,
      qed: (json['qed'] as num?)?.toDouble() ?? 0,
      saScore: (json['sa_score'] as num?)?.toDouble() ?? 0,
      predPAffMean: (json['pred_pAff_mean'] as num?)?.toDouble() ?? 0,
      dockingScore: (json['docking_score'] as num?)?.toDouble(),
      dockingStatus: json['docking_status'] as String?,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );
  }

  LigandEntity toEntity({DateTime? generatedAt}) {
    return LigandEntity(
      id: rank.toString(),
      candidateName: 'Candidate #${rank.toString().padLeft(5, '0')}',
      smiles: canonicalSmiles.isNotEmpty ? canonicalSmiles : smiles,
      generatedAt: generatedAt ?? DateTime.now(),
      rank: rank,
      valid: valid,
      canonicalSmiles: canonicalSmiles.isNotEmpty ? canonicalSmiles : null,
      smilesState: smilesState,
      nll: nll,
      mw: mw,
      logp: logp,
      tpsa: tpsa,
      hbd: hbd,
      hba: hba,
      rotBonds: rotBonds,
      qed: qed,
      saScore: saScore,
      predPAffMean: predPAffMean,
      dockingScore: dockingScore,
      dockingStatus: dockingStatus,
    );
  }
}
