import '../../domain/entities/admet_prediction_entity.dart';

class AdmetPredictionModel {
  final String smiles;
  final double absorption;
  final double distribution;
  final double metabolism;
  final double excretion;
  final double toxicity;
  final String? source;
  final String? error;

  const AdmetPredictionModel({
    required this.smiles,
    this.absorption = 0,
    this.distribution = 0,
    this.metabolism = 0,
    this.excretion = 0,
    this.toxicity = 0,
    this.source,
    this.error,
  });

  factory AdmetPredictionModel.fromJson(Map<String, dynamic> json) {
    return AdmetPredictionModel(
      smiles: (json['smiles'] ?? '') as String,
      absorption: (json['absorption'] as num?)?.toDouble() ?? 0.0,
      distribution: (json['distribution'] as num?)?.toDouble() ?? 0.0,
      metabolism: (json['metabolism'] as num?)?.toDouble() ?? 0.0,
      excretion: (json['excretion'] as num?)?.toDouble() ?? 0.0,
      toxicity: (json['toxicity'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String?,
      error: json['error'] as String?,
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
      if (source != null) 'source': source,
      if (error != null) 'error': error,
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
      source: source,
      error: error,
    );
  }
}
