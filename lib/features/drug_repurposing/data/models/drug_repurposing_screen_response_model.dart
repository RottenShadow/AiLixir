import '../../domain/entities/drug_repurposing_screen_response_entity.dart';
import 'drug_repurposing_base_model.dart';
import 'drug_repurposing_top_candidate_model.dart';

class DrugRepurposingScreenResponseModel extends DrugRepurposingBaseModel {
  final int totalTargetsFound;
  final int totalDrugsScreened;
  final int totalPairsEvaluated;
  final List<DrugRepurposingTopCandidateModel> topCandidates;
  final List<String> warnings;

  const DrugRepurposingScreenResponseModel({
    required super.diseaseName,
    required this.totalTargetsFound,
    required this.totalDrugsScreened,
    required this.totalPairsEvaluated,
    required this.topCandidates,
    required this.warnings,
  });

  /// Creates a [DrugRepurposingScreenResponseModel] from JSON map.
  factory DrugRepurposingScreenResponseModel.fromJson(Map<String, dynamic> json) {
    final String diseaseName = (json['disease_name'] ?? json['disease'] ?? '') as String;

    final topResults = (json['top_results'] as List?)?.map((e) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(e as Map);
      map['disease_name'] = diseaseName;
      return DrugRepurposingTopCandidateModel.fromJson(map);
    }).toList() ?? const [];

    return DrugRepurposingScreenResponseModel(
      diseaseName: diseaseName,
      totalTargetsFound: (json['total_targets_found'] as num?)?.toInt() ?? 0,
      totalDrugsScreened: (json['total_drugs'] as num?)?.toInt() ?? 0,
      totalPairsEvaluated: (json['total_predictions'] as num?)?.toInt() ?? 0,
      topCandidates: topResults,
      warnings: (json['warnings'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  /// Maps the model to its domain entity
  DrugRepurposingScreenResponseEntity toEntity() {
    return DrugRepurposingScreenResponseEntity(
      diseaseName: diseaseName,
      totalTargetsFound: totalTargetsFound,
      totalDrugsScreened: totalDrugsScreened,
      totalPairsEvaluated: totalPairsEvaluated,
      topCandidates: topCandidates.map((e) => e.toEntity()).toList(),
      warnings: warnings,
    );
  }
}
