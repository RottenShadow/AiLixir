import 'package:ailixir/features/generation/data/models/generation_files_model.dart';
import 'package:ailixir/features/generation/data/models/ligand_model.dart';
import 'package:ailixir/features/generation/domain/entities/generation_result_entity.dart';

class GenerationSummaryModel {
  final int numRequested;
  final int numGenerated;
  final int numValid;
  final int numReturned;
  final int numDocked;

  const GenerationSummaryModel({
    required this.numRequested,
    required this.numGenerated,
    required this.numValid,
    required this.numReturned,
    required this.numDocked,
  });

  factory GenerationSummaryModel.fromJson(Map<String, dynamic> json) {
    return GenerationSummaryModel(
      numRequested: (json['num_requested'] as num?)?.toInt() ?? 0,
      numGenerated: (json['num_generated'] as num?)?.toInt() ?? 0,
      numValid: (json['num_valid'] as num?)?.toInt() ?? 0,
      numReturned: (json['num_returned'] as num?)?.toInt() ?? 0,
      numDocked: (json['num_docked'] as num?)?.toInt() ?? 0,
    );
  }

  GenerationSummaryEntity toEntity() {
    return GenerationSummaryEntity(
      numRequested: numRequested,
      numGenerated: numGenerated,
      numValid: numValid,
      numReturned: numReturned,
      numDocked: numDocked,
    );
  }
}

class GenerationResultModel {
  final String jobId;
  final String status;
  final GenerationSummaryModel? summary;
  final List<LigandModel> ligands;
  final GenerationFilesModel? files;
  final DateTime? createdAt;

  const GenerationResultModel({
    required this.jobId,
    required this.status,
    this.summary,
    required this.ligands,
    this.files,
    this.createdAt,
  });

  factory GenerationResultModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? raw) {
      if (raw == null || raw.isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return GenerationResultModel(
      jobId: json['job_id'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      summary: json['summary'] != null
          ? GenerationSummaryModel.fromJson(
              json['summary'] as Map<String, dynamic>)
          : null,
      files: json['files'] != null
          ? GenerationFilesModel.fromJson(json['files'] as Map<String, dynamic>)
          : null,
      ligands: (json['ligands'] as List<dynamic>?)
              ?.map((e) =>
                  LigandModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: parseDate(json['created_at'] as String?),
    );
  }

  GenerationResultEntity toEntity() {
    return GenerationResultEntity(
      jobId: jobId,
      status: status,
      summary: summary?.toEntity(),
      files: files?.toEntity(),
      ligands: ligands
          .map((l) => l.toEntity(generatedAt: createdAt))
          .toList(),
      createdAt: createdAt,
    );
  }
}
