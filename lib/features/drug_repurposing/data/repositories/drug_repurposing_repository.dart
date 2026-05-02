import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/api/app_endpoints.dart';
import '../../domain/entities/drug_repurposing_screen_request_entity.dart';
import '../../domain/entities/drug_repurposing_screen_response_entity.dart';
import '../../domain/entities/drug_repurposing_targets_response_entity.dart';
import '../models/drug_repurposing_screen_request_model.dart';
import '../models/drug_repurposing_screen_response_model.dart';
import '../models/drug_repurposing_targets_response_model.dart';

/// Repository class for drug repurposing operations.
/// This implementation calls the API directly using Dio.
class DrugRepurposingRepository {
  final DioService dio;
  final Dio dioInstance = Dio(
    BaseOptions(
      baseUrl: AppEndpoints.drugRepurposingBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  DrugRepurposingRepository({required this.dio});

  /// Screens drug candidates for a given disease.
  Future<DrugRepurposingScreenResponseEntity> screenDrugs(
    DrugRepurposingScreenRequestEntity request,
  ) async {
    try {
      final requestModel = DrugRepurposingScreenRequestModel.fromEntity(
        request,
      );

      final res = await dio.post(
        endpoint: AppEndpoints.drugRepurposingScreen,
        data: requestModel.toJson(),
      );

      return DrugRepurposingScreenResponseModel.fromJson(res).toEntity();
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['detail'] ?? e.message;
      throw Exception('Drug screening failed: $errorMessage');
    } catch (e) {
      throw Exception('An unexpected error occurred during screening: $e');
    }
  }

  /// Fetches molecular targets for a specific [diseaseName].
  Future<DrugRepurposingTargetsResponseEntity> getTargets(
    String diseaseName,
  ) async {
    try {
      final res = await dio.get(
        endpoint: AppEndpoints.drugRepurposingTargets(diseaseName),
      );

      return DrugRepurposingTargetsResponseModel.fromJson(res).toEntity();
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['detail'] ?? e.message;
      throw Exception('Failed to fetch targets: $errorMessage');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching targets: $e',
      );
    }
  }
}
