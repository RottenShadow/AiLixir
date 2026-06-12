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

  Map<String, dynamic> toJson() {
    return {
      'disease_name': diseaseName,
      'known_drugs': knownDrugs,
      'min_score': minScore,
      'top_n_targets': topNTargets,
    };
  }
}
