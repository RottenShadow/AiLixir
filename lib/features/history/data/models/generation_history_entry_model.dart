import 'package:ailixir/core/entities/generation_job_history_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/features/generation/data/models/generation_files_model.dart';
import 'package:ailixir/features/generation/data/models/ligand_model.dart';

class GenerationHistoryEntryModel {
  final String id;
  final String jobId;
  final String status;
  final String preset;
  final int numMolecules;
  final int returnTopK;
  final String dockingMode;
  final int dockTopK;
  final String? stage;
  final GenerationFilesModel? files;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LigandModel> ligands;

  const GenerationHistoryEntryModel({
    required this.id,
    required this.jobId,
    required this.status,
    required this.preset,
    required this.numMolecules,
    required this.returnTopK,
    required this.dockingMode,
    required this.dockTopK,
    this.stage,
    this.files,
    required this.createdAt,
    required this.updatedAt,
    this.ligands = const [],
  });

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  factory GenerationHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    final ligandsRaw = json['ligands'] as List<dynamic>?;
    return GenerationHistoryEntryModel(
      id: (json['id'] as num?)?.toString() ?? '',
      jobId: json['job_id'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      preset: json['preset'] as String? ?? '',
      numMolecules: (json['num_molecules'] as num?)?.toInt() ?? 0,
      returnTopK: (json['return_top_k'] as num?)?.toInt() ?? 0,
      dockingMode: json['docking_mode'] as String? ?? 'off',
      dockTopK: (json['dock_top_k'] as num?)?.toInt() ?? 0,
      stage: json['stage'] as String?,
      files: json['files'] != null
          ? GenerationFilesModel.fromJson(json['files'] as Map<String, dynamic>)
          : null,
      createdAt: _parseDate(json['created_at'] as String?) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at'] as String?) ?? DateTime.now(),
      ligands: ligandsRaw != null
          ? ligandsRaw
                .map((e) => LigandModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  GenerationJobHistoryEntity toEntity() {
    final entityLigands = ligands.map((l) {
      final base = l.toEntity(generatedAt: createdAt);
      return LigandEntity(
        id: '${id}_${base.id}',
        candidateName: base.candidateName,
        smiles: base.smiles,
        generatedAt: base.generatedAt,
        rank: base.rank,
        valid: base.valid,
        canonicalSmiles: base.canonicalSmiles,
        smilesState: base.smilesState,
        nll: base.nll,
        mw: base.mw,
        logp: base.logp,
        tpsa: base.tpsa,
        hbd: base.hbd,
        hba: base.hba,
        rotBonds: base.rotBonds,
        qed: base.qed,
        saScore: base.saScore,
        predPAffMean: base.predPAffMean,
        dockingScore: base.dockingScore,
        dockingStatus: base.dockingStatus,
      );
    }).toList();

    return GenerationJobHistoryEntity(
      id: id,
      jobId: jobId,
      status: status,
      preset: preset,
      numMolecules: numMolecules,
      returnTopK: returnTopK,
      dockingMode: dockingMode,
      dockTopK: dockTopK,
      stage: stage,
      files: files?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      ligands: entityLigands,
    );
  }
}
