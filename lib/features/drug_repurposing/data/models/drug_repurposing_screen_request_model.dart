import '../../domain/entities/drug_repurposing_screen_request_entity.dart';

class DrugRepurposingScreenRequestModel extends DrugRepurposingScreenRequestEntity {
  const DrugRepurposingScreenRequestModel({
    required super.diseaseName,
    required super.knownDrugs,
    required super.extraSmiles,
    required super.topK,
  });

  factory DrugRepurposingScreenRequestModel.fromEntity(
    DrugRepurposingScreenRequestEntity entity,
  ) {
    return DrugRepurposingScreenRequestModel(
      diseaseName: entity.diseaseName,
      knownDrugs: entity.knownDrugs,
      extraSmiles: entity.extraSmiles,
      topK: entity.topK,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_name': diseaseName,
      'known_drugs': knownDrugs,
      'extra_smiles': extraSmiles,
      'top_k': topK,
    };
  }
}
