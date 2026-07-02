import 'package:ailixir/features/admet/data/models/admet_data_model.dart';
import 'package:ailixir/features/admet/domain/entities/admet_predict_response_entity.dart';

class AdmetPredictResponseModel {
  final AdmetDataModel data;

  const AdmetPredictResponseModel({required this.data});

  factory AdmetPredictResponseModel.fromJson(Map<String, dynamic> json) {
    return AdmetPredictResponseModel(
      data: AdmetDataModel.fromJson(json),
    );
  }

  AdmetPredictResponseEntity toEntity() {
    return AdmetPredictResponseEntity(
      results: data.results.map((e) => e.toEntity()).toList(),
      totalProcessed: data.totalProcessed,
      totalSmiles: data.totalSmiles,
    );
  }
}
