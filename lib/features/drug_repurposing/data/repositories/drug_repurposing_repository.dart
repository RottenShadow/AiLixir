import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import '../../domain/entities/drug_repurposing_job_entity.dart';
import '../../domain/entities/drug_repurposing_screen_job_entity.dart';
import '../../domain/entities/drug_repurposing_screen_request_entity.dart';
import '../../domain/entities/drug_repurposing_target_job_entity.dart';
import '../models/drug_repurposing_job_model.dart';
import '../models/drug_repurposing_screen_job_model.dart';
import '../models/drug_repurposing_screen_request_model.dart';
import '../models/drug_repurposing_target_job_model.dart';

class DrugRepurposingRepository {
  final DioService dio;

  DrugRepurposingRepository({required this.dio});

  Future<Either<Failure, DrugRepurposingJobEntity>> submitTargetsJob({
    required String diseaseName,
    int topN = 10,
  }) async {
    return safeApiCall(() async {
      final response = await dio.post(
        endpoint: AppEndpoints.drugRepurposingTargets,
        data: {'disease_name': diseaseName, 'top_n': topN},
      );
      return DrugRepurposingJobModel.fromJson(
        response as Map<String, dynamic>,
      ).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingTargetJobEntity>> getTargetsJobStatus(
    int jobId,
  ) async {
    return safeApiCall(() async {
      final response = await dio.get(
        endpoint: AppEndpoints.drugRepurposingTargetsStatus(jobId),
      );
      return DrugRepurposingTargetJobModel.fromJson(
        response as Map<String, dynamic>,
      ).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingJobEntity>> submitScreenJob(
    DrugRepurposingScreenRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final requestModel = DrugRepurposingScreenRequestModel.fromEntity(request);
      final response = await dio.post(
        endpoint: AppEndpoints.drugRepurposingScreen,
        data: requestModel.toJson(),
      );
      return DrugRepurposingJobModel.fromJson(
        response as Map<String, dynamic>,
      ).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingScreenJobEntity>> getScreenJobStatus(
    int jobId,
  ) async {
    return safeApiCall(() async {
      final response = await dio.get(
        endpoint: AppEndpoints.drugRepurposingScreenStatus(jobId),
      );
      return DrugRepurposingScreenJobModel.fromJson(
        response as Map<String, dynamic>,
      ).toEntity();
    });
  }
}
