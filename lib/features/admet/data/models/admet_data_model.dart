import 'package:ailixir/features/admet/data/models/admet_prediction_model.dart';

class AdmetDataModel {
  final int totalProcessed;
  final int totalSmiles;
  final List<AdmetPredictionModel> results;

  const AdmetDataModel({
    this.totalProcessed = 0,
    this.totalSmiles = 0,
    this.results = const [],
  });

  factory AdmetDataModel.fromJson(Map<String, dynamic> json) {
    return AdmetDataModel(
      totalProcessed: (json['total_processed'] as num?)?.toInt() ?? 0,
      totalSmiles: (json['total_smiles'] as num?)?.toInt() ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => AdmetPredictionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
