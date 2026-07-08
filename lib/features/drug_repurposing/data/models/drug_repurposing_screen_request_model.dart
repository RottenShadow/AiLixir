import '../../domain/entities/drug_repurposing_screen_request_entity.dart';

class DrugRepurposingScreenRequestModel extends DrugRepurposingScreenRequestEntity {
  const DrugRepurposingScreenRequestModel({
    required super.diseaseName,
    required super.knownDrugs,
    super.minScore = 0.0,
    super.topNTargets = 10,
  });

  factory DrugRepurposingScreenRequestModel.fromEntity(
    DrugRepurposingScreenRequestEntity entity,
  ) {
    return DrugRepurposingScreenRequestModel(
      diseaseName: entity.diseaseName,
      knownDrugs: entity.knownDrugs,
      minScore: entity.minScore,
      topNTargets: entity.topNTargets,
    );
  }

  factory DrugRepurposingScreenRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DrugRepurposingScreenRequestModel(
      diseaseName: (json['disease_name'] ?? '') as String,
      knownDrugs: (json['known_drugs'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      minScore: (json['min_score'] as num?)?.toDouble() ?? 0.0,
      topNTargets: (json['top_n_targets'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_name': diseaseName,
      'known_drugs': knownDrugs,
      'min_score': minScore,
      'top_n_targets': topNTargets,
    };
  }
}
