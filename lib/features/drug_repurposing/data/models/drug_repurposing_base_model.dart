import '../../domain/entities/drug_repurposing_base_entity.dart';

/// Base class for all models in the drug_repurposing feature
abstract class DrugRepurposingBaseModel extends DrugRepurposingBaseEntity {
  const DrugRepurposingBaseModel({
    required super.diseaseName,
  });
}
