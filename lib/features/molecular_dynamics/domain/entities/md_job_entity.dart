class MdJobEntity {
  final String remoteJobId;
  final String status;
  final String? remoteStatus;
  final String? protein;
  final String? ligand;
  final String? resultDownloadUrl;
  final String? analysisDownloadUrl;
  final String? errorMessage;
  final DateTime createdAt;

  const MdJobEntity({
    required this.remoteJobId,
    required this.status,
    this.remoteStatus,
    this.protein,
    this.ligand,
    this.resultDownloadUrl,
    this.analysisDownloadUrl,
    this.errorMessage,
    required this.createdAt,
  });

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isProcessing =>
      status == 'processing' || status == 'running' || status == 'pending';

  bool get hasResults => resultDownloadUrl != null && isCompleted;
  bool get hasAnalysis => analysisDownloadUrl != null && isCompleted;
}
