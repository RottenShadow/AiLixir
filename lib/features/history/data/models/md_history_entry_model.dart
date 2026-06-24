import 'package:ailixir/core/entities/md_entity.dart';

class MdHistoryEntryModel {
  final String remoteJobId;
  final String status;
  final String proteinName;
  final String ligandName;
  final Map<String, dynamic>? inputParams;
  final Map<String, dynamic>? resultMeta;
  final Map<String, dynamic>? analysisMeta;
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
    required this.createdAt,
    required this.updatedAt,
  });

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
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
      createdAt: _parseDate(json['created_at'] as String?) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at'] as String?) ?? DateTime.now(),
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
    return ff ?? 'Unknown';
  }

  String get _derivedDuration {
    final simTime = inputParams?['sim_time_ns'] as String?;
    return simTime != null ? '$simTime ns' : '—';
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
    );
  }
}
