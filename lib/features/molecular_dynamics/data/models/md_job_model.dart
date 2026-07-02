import 'package:ailixir/features/molecular_dynamics/domain/entities/md_job_entity.dart';

class MdJobModel {
  final String remoteJobId;
  final String status;
  final String? remoteStatus;
  final String? protein;
  final String? ligand;
  final Map<String, dynamic>? resultMeta;
  final Map<String, dynamic>? analysisMeta;
  final String? errorMessage;
  final String createdAt;

  const MdJobModel({
    required this.remoteJobId,
    required this.status,
    this.remoteStatus,
    this.protein,
    this.ligand,
    this.resultMeta,
    this.analysisMeta,
    this.errorMessage,
    required this.createdAt,
  });

  factory MdJobModel.fromJson(Map<String, dynamic> json) {
    return MdJobModel(
      remoteJobId: json['remote_job_id'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      remoteStatus: json['remote_status'] as String?,
      protein: json['protein'] as String?,
      ligand: json['ligand'] as String?,
      resultMeta: json['result_meta'] as Map<String, dynamic>?,
      analysisMeta: json['analysis_meta'] as Map<String, dynamic>?,
      errorMessage: json['error_message'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  MdJobEntity toEntity() {
    String? resultDownloadUrl;
    String? analysisDownloadUrl;

    if (resultMeta != null) {
      resultDownloadUrl = resultMeta!['download_url'] as String?;
      analysisDownloadUrl = resultMeta!['download_analysis_url'] as String?;
    }

    return MdJobEntity(
      remoteJobId: remoteJobId,
      status: status,
      remoteStatus: remoteStatus,
      protein: protein,
      ligand: ligand,
      resultDownloadUrl: resultDownloadUrl,
      analysisDownloadUrl: analysisDownloadUrl,
      errorMessage: errorMessage,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}
