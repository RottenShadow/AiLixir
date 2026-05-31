import '../../domain/entities/admet_prediction_entity.dart';

class AdmetPredictionModel {
  final String smiles;
  final double absorption;
  final double distribution;
  final double metabolism;
  final double excretion;
  final double toxicity;

  const AdmetPredictionModel({
    required this.smiles,
    required this.absorption,
    required this.distribution,
    required this.metabolism,
    required this.excretion,
    required this.toxicity,
  });

  factory AdmetPredictionModel.fromJson(Map<String, dynamic> json) {
    return AdmetPredictionModel(
      smiles: (json['smiles'] ?? '') as String,
      absorption: (json['absorption'] as num?)?.toDouble() ?? 0.0,
      distribution: (json['distribution'] as num?)?.toDouble() ?? 0.0,
      metabolism: (json['metabolism'] as num?)?.toDouble() ?? 0.0,
      excretion: (json['excretion'] as num?)?.toDouble() ?? 0.0,
      toxicity: (json['toxicity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'smiles': smiles,
      'absorption': absorption,
      'distribution': distribution,
      'metabolism': metabolism,
      'excretion': excretion,
      'toxicity': toxicity,
    };
  }

  AdmetPredictionEntity toEntity() {
    return AdmetPredictionEntity(
      smiles: smiles,
      absorption: absorption,
      distribution: distribution,
      metabolism: metabolism,
      excretion: excretion,
      toxicity: toxicity,
    );
  }
}
