import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/features/admet/data/models/admet_data_model.dart';
import 'package:ailixir/features/admet/domain/entities/admet_predict_response_entity.dart';

class AdmetPredictResponseModel {
  final BaseResponseModel<AdmetDataModel> base;

  const AdmetPredictResponseModel({required this.base});

  factory AdmetPredictResponseModel.fromJson(Map<String, dynamic> json) {
    return AdmetPredictResponseModel(
      base: BaseResponseModel<AdmetDataModel>.fromJson(
        json,
        (data) => AdmetDataModel.fromJson(data as Map<String, dynamic>),
      ),
    );
  }

  AdmetPredictResponseEntity toEntity() {
    return AdmetPredictResponseEntity(
      results: base.data?.results.map((e) => e.toEntity()).toList() ?? [],
      totalProcessed: base.data?.totalProcessed ?? 0,
      totalSmiles: base.data?.totalSmiles ?? 0,
    );
  }
}
