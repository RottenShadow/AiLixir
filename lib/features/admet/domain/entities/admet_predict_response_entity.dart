import 'admet_prediction_entity.dart';

class AdmetPredictResponseEntity {
  final bool success;
  final String message;
  final List<AdmetPredictionEntity> data;

  const AdmetPredictResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
