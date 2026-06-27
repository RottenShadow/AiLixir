import 'package:ailixir/core/entities/generation_files_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';

class GenerationJobHistoryEntity {
  final String id;
  final String jobId;
  final String status;
  final String preset;
  final int numMolecules;
  final int returnTopK;
  final String dockingMode;
  final int dockTopK;
  final String? stage;
  final String? summary;
  final GenerationFilesEntity? files;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LigandEntity> ligands;

  const GenerationJobHistoryEntity({
    required this.id,
    required this.jobId,
    required this.status,
    required this.preset,
    required this.numMolecules,
    required this.returnTopK,
    required this.dockingMode,
    required this.dockTopK,
    this.stage,
    this.summary,
    this.files,
    required this.createdAt,
    required this.updatedAt,
    this.ligands = const [],
  });

  bool get isRunning => status == 'running';
  bool get isFailed => status == 'failed';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}
