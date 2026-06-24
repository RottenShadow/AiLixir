import 'package:ailixir/core/entities/drug_repurposing_entity.dart';

class DrugRepurposingScreenEntryModel {
  final String id;
  final String diseaseName;
  final String status;
  final int totalCandidates;
  final int totalDrugsScreened;
  final int totalPairsEvaluated;
  final int totalTargetsFound;
  final DateTime createdAt;
  final List<DrugRepurposingHistoryCandidate> topCandidates;

  const DrugRepurposingScreenEntryModel({
    required this.id,
    required this.diseaseName,
    required this.status,
    required this.totalCandidates,
    required this.totalDrugsScreened,
    required this.totalPairsEvaluated,
    required this.totalTargetsFound,
    required this.createdAt,
    required this.topCandidates,
  });

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  factory DrugRepurposingScreenEntryModel.fromJson(Map<String, dynamic> json) {
    final input = json['input'] as Map<String, dynamic>? ?? {};
    final output = json['output'] as Map<String, dynamic>?;
    final rawCandidates = (output?['top_candidates'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
    return DrugRepurposingScreenEntryModel(
      id: (json['id'] as num?)?.toString() ?? '',
      diseaseName: input['disease_name'] as String? ?? 'Unknown',
      status: json['status'] as String? ?? 'unknown',
      totalCandidates: rawCandidates.length,
      totalDrugsScreened: (output?['total_drugs_screened'] as num?)?.toInt() ?? 0,
      totalPairsEvaluated: (output?['total_pairs_evaluated'] as num?)?.toInt() ?? 0,
      totalTargetsFound: (output?['total_targets_found'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['created_at'] as String?) ?? DateTime.now(),
      topCandidates: rawCandidates.map((e) => DrugRepurposingHistoryCandidate(
        drugName: (e['drug_name'] as String?) ?? '',
        smiles: (e['smiles'] as String?) ?? '',
        targetSymbol: (e['target_symbol'] as String?) ?? '',
        uniprotId: (e['uniprot_id'] as String?) ?? '',
        bindingScore: (e['binding_score'] as num?)?.toDouble() ?? 0.0,
        rank: (e['rank'] as num?)?.toInt() ?? 0,
        status: (e['status'] as String?) ?? '',
      )).toList(),
    );
  }

  DrugRepurposingEntity toEntity() {
    return DrugRepurposingEntity(
      id: id,
      type: DrugRepurposingType.screen,
      diseaseName: diseaseName,
      status: status,
      createdAt: createdAt,
      resultCount: totalCandidates,
      totalDrugsScreened: totalDrugsScreened,
      totalPairsEvaluated: totalPairsEvaluated,
      topCandidates: topCandidates,
    );
  }
}
