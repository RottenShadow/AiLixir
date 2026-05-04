import '../../domain/entities/drug_repurposing_targets_response_entity.dart';
import 'drug_repurposing_base_model.dart';
import 'drug_repurposing_target_model.dart';

class DrugRepurposingTargetsResponseModel extends DrugRepurposingBaseModel {
  final String diseaseId;
  final int totalTargets;
  final List<DrugRepurposingTargetModel> targets;

  const DrugRepurposingTargetsResponseModel({
    required super.diseaseName,
    required this.diseaseId,
    required this.totalTargets,
    required this.targets,
  });

  /// Creates a [DrugRepurposingTargetsResponseModel] from JSON map.
  factory DrugRepurposingTargetsResponseModel.fromJson(Map<String, dynamic> json) {
    final String diseaseName = (json['disease_name'] ?? json['disease'] ?? '') as String;

    return DrugRepurposingTargetsResponseModel(
      diseaseName: diseaseName,
      diseaseId: (json['disease_id'] ?? '') as String,
      totalTargets: (json['total_targets'] as num?)?.toInt() ?? 0,
      targets: (json['targets'] as List?)?.map((e) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(e as Map);
        map['disease'] = diseaseName;
        return DrugRepurposingTargetModel.fromJson(map);
      }).toList() ?? const [],
    );
  }

  /// Maps the model to its domain entity
  DrugRepurposingTargetsResponseEntity toEntity() {
    return DrugRepurposingTargetsResponseEntity(
      diseaseName: diseaseName,
      diseaseId: diseaseId,
      totalTargets: totalTargets,
      targets: targets.map((e) => e.toEntity()).toList(),
    );
  }
}
