import 'package:ailixir/features/admet/data/models/admet_prediction_model.dart';
import 'package:ailixir/features/admet/domain/entities/admet_predict_response_entity.dart';

class AdmetPredictResponseModel {
  final bool success;
  final String message;
  final List<AdmetPredictionModel> data;

  const AdmetPredictResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AdmetPredictResponseModel.fromJson(Map<String, dynamic> json) {
    return AdmetPredictResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AdmetPredictionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  AdmetPredictResponseEntity toEntity() {
    return AdmetPredictResponseEntity(
      success: success,
      message: message,
      data: data.map((e) => e.toEntity()).toList(),
    );
  }
}
