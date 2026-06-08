import 'package:ailixir/core/entities/ligand_entity.dart';

class GenerationSummaryEntity {
  final int numRequested;
  final int numGenerated;
  final int numValid;
  final int numReturned;
  final int numDocked;

  const GenerationSummaryEntity({
    required this.numRequested,
    required this.numGenerated,
    required this.numValid,
    required this.numReturned,
    required this.numDocked,
  });
}

class GenerationResultEntity {
  final String jobId;
  final String status;
  final GenerationSummaryEntity? summary;
  final List<LigandEntity> ligands;
  final DateTime? createdAt;

  const GenerationResultEntity({
    required this.jobId,
    required this.status,
    this.summary,
    required this.ligands,
    this.createdAt,
  });
}
