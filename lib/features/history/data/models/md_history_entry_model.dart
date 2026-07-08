import 'package:ailixir/core/entities/md_entity.dart';

class MdHistoryEntryModel {
  final String remoteJobId;
  final String status;
  final String proteinName;
  final String ligandName;
  final Map<String, dynamic>? inputParams;
  final Map<String, dynamic>? resultMeta;
  final Map<String, dynamic>? analysisMeta;
  final String? remoteStatus;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MdHistoryEntryModel({
    required this.remoteJobId,
    required this.status,
    required this.proteinName,
    required this.ligandName,
    this.inputParams,
    this.resultMeta,
    this.analysisMeta,
    this.remoteStatus,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  factory MdHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return MdHistoryEntryModel(
      remoteJobId: json['remote_job_id'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      proteinName: json['protein_original_name'] as String? ?? '',
      ligandName: json['ligand_original_name'] as String? ?? '',
      inputParams: json['input_params'] as Map<String, dynamic>?,
      resultMeta: json['result_meta'] as Map<String, dynamic>?,
      analysisMeta: json['analysis_meta'] as Map<String, dynamic>?,
      remoteStatus: json['remote_status'] as String?,
      errorMessage: json['error_message'] as String?,
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
    );
  }

  MdStatus get _derivedStatus {
    switch (status) {
      case 'completed':
        return MdStatus.completed;
      case 'running':
      case 'processing':
        return MdStatus.running;
      default:
        return MdStatus.failed;
    }
  }

  String get _derivedForcefield {
    final ff = inputParams?['force_field'] as String?;
    return ff?.isNotEmpty == true ? ff! : '—';
  }

  String get _derivedDuration {
    final simTime = inputParams?['sim_time_ns'];
    return simTime != null ? '$simTime ns' : '—';
  }

  MdResultMeta? get _derivedResultMeta {
    if (resultMeta == null) return null;
    return MdResultMeta(
      downloadUrl: resultMeta!['download_url'] as String?,
      downloadAnalysisUrl: resultMeta!['download_analysis_url'] as String?,
    );
  }

  MdAnalysisMeta? get _derivedAnalysisMeta {
    if (analysisMeta == null) return null;
    final outputs = (analysisMeta!['outputs'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    return MdAnalysisMeta(
      downloadUrl: analysisMeta!['download_url'] as String?,
      outputs: outputs,
    );
  }

  MdEntity toEntity() {
    return MdEntity(
      id: remoteJobId,
      simulationTask: proteinName.isNotEmpty
          ? '$proteinName + ${ligandName.isNotEmpty ? ligandName : 'ligand'}'
          : remoteJobId,
      createdAt: createdAt,
      forcefield: _derivedForcefield,
      duration: _derivedDuration,
      status: _derivedStatus,
      proteinName: proteinName,
      ligandName: ligandName,
      remoteStatus: remoteStatus,
      errorMessage: errorMessage,
      resultMeta: _derivedResultMeta,
      analysisMeta: _derivedAnalysisMeta,
    );
  }
}
