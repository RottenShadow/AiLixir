import 'dart:io';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/admet/data/models/admet_predict_response_model.dart';
import 'package:ailixir/features/admet/domain/entities/admet_predict_response_entity.dart';
import 'package:ailixir/features/admet/domain/entities/admet_prediction_entity.dart';

class AdmetRepo {
  final DioService dioService;

  AdmetRepo({required this.dioService});

  Future<Either<Failure, AdmetPredictResponseEntity>> predictAdmet(
    List<String> smiles,
  ) async {
    if (AppFeatureFlag.useFakeAdmet) {
      return _fakePredict(smiles);
    }
    return safeApiCall(() async {
      final response =
          await dioService.post(
                endpoint: AppEndpoints.admetPredict,
                data: {'smiles': smiles.join(', ')},
              )
              as Map<String, dynamic>;
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response,
        (d) => d as Map<String, dynamic>,
      );
      return AdmetPredictResponseModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, AdmetPredictResponseEntity>> predictAdmetFromFile(
    String filePath,
  ) async {
    if (AppFeatureFlag.useFakeAdmet) {
      return _fakePredictFromFile(filePath);
    }
    return safeApiCall(() async {
      File file = File(filePath);
      final formData = await DioService.buildFormData({'file': file});
      final response =
          await dioService.post(
                endpoint: AppEndpoints.admetPredict,
                data: formData,
              )
              as Map<String, dynamic>;
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response,
        (d) => d as Map<String, dynamic>,
      );
      return AdmetPredictResponseModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, AdmetPredictResponseEntity>> _fakePredict(
    List<String> smiles,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final random = Random();
    final predictions = smiles
        .map(
          (s) => AdmetPredictionEntity(
            smiles: s.trim(),
            absorption: -3.5 + random.nextDouble() * 2.5,
            distribution: 0.5 + random.nextDouble() * 1.2,
            metabolism: -0.4 + random.nextDouble() * 0.5,
            excretion: 5.0 + random.nextDouble() * 18.0,
            toxicity: -0.8 + random.nextDouble() * 2.0,
          ),
        )
        .toList();
    return Right(AdmetPredictResponseEntity(results: predictions));
  }

  Future<Either<Failure, AdmetPredictResponseEntity>> _fakePredictFromFile(
    String filePath,
  ) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final random = Random();
    final fakeSmiles = [
      'c1ccccc1',
      'CCO',
      'CCC',
      'CC(=O)O',
      'c1ccccc1O',
      'CCN',
      'CC(C)=O',
      'CCCC',
      'c1ccncc1',
      'CCCO',
    ];
    final predictions = fakeSmiles
        .map(
          (s) => AdmetPredictionEntity(
            smiles: s.trim(),
            absorption: -3.5 + random.nextDouble() * 2.5,
            distribution: 0.5 + random.nextDouble() * 1.2,
            metabolism: -0.4 + random.nextDouble() * 0.5,
            excretion: 5.0 + random.nextDouble() * 18.0,
            toxicity: -0.8 + random.nextDouble() * 2.0,
          ),
        )
        .toList();
    return Right(AdmetPredictResponseEntity(results: predictions));
  }
}
