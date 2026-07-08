import 'package:ailixir/core/entities/drug_repurposing_entity.dart';

class DrugRepurposingTargetsEntryModel {
  final String id;
  final String diseaseName;
  final int topN;
  final String status;
  final int totalTargets;
  final DateTime createdAt;
  final List<DrugRepurposingHistoryTarget> targets;

  const DrugRepurposingTargetsEntryModel({
    required this.id,
    required this.diseaseName,
    required this.topN,
    required this.status,
    required this.totalTargets,
    required this.createdAt,
    required this.targets,
  });

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  factory DrugRepurposingTargetsEntryModel.fromJson(Map<String, dynamic> json) {
    final input = json['input'] as Map<String, dynamic>? ?? {};
    final output = json['output'] as Map<String, dynamic>?;
    final rawTargets =
        (output?['targets'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
    return DrugRepurposingTargetsEntryModel(
      id: (json['id'] as num?)?.toString() ?? '',
      diseaseName: input['disease_name'] as String? ?? 'Unknown',
      topN: (input['top_n'] as num?)?.toInt() ?? 10,
      status: json['status'] as String? ?? 'unknown',
      totalTargets: (output?['total_targets'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['created_at'] as String?) ?? DateTime.now(),
      targets: rawTargets
          .map(
            (e) => DrugRepurposingHistoryTarget(
              symbol: (e['symbol'] as String?) ?? '',
              name: (e['name'] as String?) ?? '',
              score: (e['score'] as num?)?.toDouble() ?? 0.0,
              uniprotId: (e['uniprot_id'] as String?) ?? '',
              pdbIds:
                  (e['pdb_ids'] as List<dynamic>?)
                      ?.map((p) => p as String)
                      .toList() ??
                  [],
            ),
          )
          .toList(),
    );
  }

  DrugRepurposingEntity toEntity() {
    return DrugRepurposingEntity(
      id: id,
      type: DrugRepurposingType.targets,
      diseaseName: diseaseName,
      status: status,
      createdAt: createdAt,
      resultCount: totalTargets,
      totalTargets: totalTargets,
      targets: targets,
    );
  }
}
