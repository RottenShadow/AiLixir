import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import '../../domain/entities/drug_repurposing_job_entity.dart';
import '../../domain/entities/drug_repurposing_screen_job_entity.dart';
import '../../domain/entities/drug_repurposing_screen_request_entity.dart';
import '../../domain/entities/drug_repurposing_screen_response_entity.dart';
import '../../domain/entities/drug_repurposing_target_entity.dart';
import '../../domain/entities/drug_repurposing_target_job_entity.dart';
import '../../domain/entities/drug_repurposing_targets_response_entity.dart';
import '../../domain/entities/drug_repurposing_top_candidate_entity.dart';
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
    if (AppFeatureFlag.useFakeDrugRepurposing) {
      return _fakeSubmitTargetsJob(diseaseName);
    }
    return safeApiCall(() async {
      final response = await dio.post(
        endpoint: AppEndpoints.drugRepurposingTargets,
        data: {'disease_name': diseaseName, 'top_n': topN},
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return DrugRepurposingJobModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingTargetJobEntity>> getTargetsJobStatus(
    int jobId,
  ) async {
    if (AppFeatureFlag.useFakeDrugRepurposing) {
      return _fakeGetTargetsJobStatus(jobId);
    }
    return safeApiCall(() async {
      final response = await dio.get(
        endpoint: AppEndpoints.drugRepurposingTargetsStatus(jobId),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return DrugRepurposingTargetJobModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingJobEntity>> submitScreenJob(
    DrugRepurposingScreenRequestEntity request,
  ) async {
    if (AppFeatureFlag.useFakeDrugRepurposing) {
      return _fakeSubmitScreenJob(request);
    }
    return safeApiCall(() async {
      final requestModel = DrugRepurposingScreenRequestModel.fromEntity(request);
      final response = await dio.post(
        endpoint: AppEndpoints.drugRepurposingScreen,
        data: requestModel.toJson(),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return DrugRepurposingJobModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingScreenJobEntity>> getScreenJobStatus(
    int jobId,
  ) async {
    if (AppFeatureFlag.useFakeDrugRepurposing) {
      return _fakeGetScreenJobStatus(jobId);
    }
    return safeApiCall(() async {
      final response = await dio.get(
        endpoint: AppEndpoints.drugRepurposingScreenStatus(jobId),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return DrugRepurposingScreenJobModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, DrugRepurposingJobEntity>> _fakeSubmitTargetsJob(
    String diseaseName,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      DrugRepurposingJobEntity(
        jobId: DateTime.now().millisecondsSinceEpoch,
        status: 'submitted',
      ),
    );
  }

  Future<Either<Failure, DrugRepurposingTargetJobEntity>> _fakeGetTargetsJobStatus(
    int jobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(
      DrugRepurposingTargetJobEntity(
        jobId: jobId,
        status: 'completed',
        createdAt: DateTime.now(),
        output: DrugRepurposingTargetsResponseEntity(
          diseaseName: 'Alzheimer',
          diseaseId: 'DOID:10652',
          totalTargets: 3,
          targets: [
            DrugRepurposingTargetEntity(
              diseaseName: 'Alzheimer',
              symbol: 'APP',
              name: 'Amyloid-beta precursor protein',
              associationScore: 0.95,
              uniprotId: 'P05067',
              pdbIds: ['1AAP', '2FK2'],
            ),
            DrugRepurposingTargetEntity(
              diseaseName: 'Alzheimer',
              symbol: 'PSEN1',
              name: 'Presenilin-1',
              associationScore: 0.88,
              uniprotId: 'P49768',
              pdbIds: ['4R7D'],
            ),
            DrugRepurposingTargetEntity(
              diseaseName: 'Alzheimer',
              symbol: 'BACE1',
              name: 'Beta-secretase 1',
              associationScore: 0.82,
              uniprotId: 'P56817',
              pdbIds: ['1FKN', '2ZJM', '3DV1'],
            ),
          ],
        ),
      ),
    );
  }

  Future<Either<Failure, DrugRepurposingJobEntity>> _fakeSubmitScreenJob(
    DrugRepurposingScreenRequestEntity request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      DrugRepurposingJobEntity(
        jobId: DateTime.now().millisecondsSinceEpoch,
        status: 'submitted',
      ),
    );
  }

  Future<Either<Failure, DrugRepurposingScreenJobEntity>> _fakeGetScreenJobStatus(
    int jobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(
      DrugRepurposingScreenJobEntity(
        jobId: jobId,
        status: 'completed',
        createdAt: DateTime.now(),
        input: const DrugRepurposingScreenRequestEntity(
          diseaseName: 'Alzheimer',
          knownDrugs: [],
          minScore: 0,
          topNTargets: 10,
        ),
        output: DrugRepurposingScreenResponseEntity(
          diseaseName: 'Alzheimer',
          totalTargetsFound: 3,
          totalDrugsScreened: 150,
          totalPairsEvaluated: 450,
          warnings: [],
          topCandidates: [
            DrugRepurposingTopCandidateEntity(
              diseaseName: 'Alzheimer',
              drugName: 'Donepezil',
              smiles: 'COc1cc2c(cc1OC)C(=O)C3=C(C2=O)C4=C(C=C(C=C4)F)CC3',
              targetSymbol: 'APP',
              uniprotId: 'P05067',
              bindingScore: -9.8,
              rank: 1,
              status: 'approved',
            ),
            DrugRepurposingTopCandidateEntity(
              diseaseName: 'Alzheimer',
              drugName: 'Memantine',
              smiles: 'CC1(C)CC2CC1C(C)(C)C2N',
              targetSymbol: 'PSEN1',
              uniprotId: 'P49768',
              bindingScore: -8.5,
              rank: 2,
              status: 'approved',
            ),
            DrugRepurposingTopCandidateEntity(
              diseaseName: 'Alzheimer',
              drugName: 'Rivastigmine',
              smiles: 'CCN(C)C(=O)OC1=C(C)C=CC=C1C',
              targetSymbol: 'BACE1',
              uniprotId: 'P56817',
              bindingScore: -7.9,
              rank: 3,
              status: 'approved',
            ),
          ],
        ),
      ),
    );
  }
}
