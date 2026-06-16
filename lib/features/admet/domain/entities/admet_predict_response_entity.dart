import 'admet_prediction_entity.dart';

class AdmetPredictResponseEntity {
  final int totalProcessed;
  final int totalSmiles;
  final List<AdmetPredictionEntity> results;

  const AdmetPredictResponseEntity({
    required this.results,
    this.totalProcessed = 0,
    this.totalSmiles = 0,
  });
}
