import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/core/entities/generation_request_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/features/generation/domain/entities/generation_job_entity.dart';
import 'package:ailixir/features/generation/domain/entities/generation_result_entity.dart';
import 'package:ailixir/features/generation/data/models/generation_request_model.dart';
import 'package:ailixir/features/generation/data/models/generation_job_status_model.dart';
import 'package:ailixir/features/generation/data/models/generation_result_model.dart';

class GenerationRepo {
  final DioService dioService;

  GenerationRepo({required this.dioService});

  Future<Either<Failure, GenerationJobEntity>> submitJob(
    GenerationRequestEntity request,
  ) async {
    if (AppFeatureFlag.useFakeGeneration) {
      return _fakeSubmitJob();
    }
    return safeApiCall(() async {
      final model = GenerationRequestModel.fromEntity(request);
      final response = await dioService.post(
        endpoint: AppEndpoints.generationRun,
        data: model.toJson(),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return GenerationJobStatusModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, GenerationJobEntity>> getJobStatus(
    String jobId,
  ) async {
    if (AppFeatureFlag.useFakeGeneration) {
      return _fakeGetJobStatus(jobId);
    }
    return safeApiCall(() async {
      final response = await dioService.get(
        endpoint: AppEndpoints.generationStatus(jobId),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return GenerationJobStatusModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, GenerationResultEntity>> getJobResults(
    String jobId,
  ) async {
    if (AppFeatureFlag.useFakeGeneration) {
      return _fakeGetJobResults(jobId);
    }
    return safeApiCall(() async {
      final response = await dioService.get(
        endpoint: AppEndpoints.generationResults(jobId),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return GenerationResultModel.fromJson(base.data!).toEntity();
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> cancelJob(String jobId) async {
    if (AppFeatureFlag.useFakeGeneration) {
      return _fakeCancelJob(jobId);
    }
    return safeApiCall(() async {
      final response = await dioService.post(
        endpoint: AppEndpoints.generationCancel(jobId),
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return base.data ?? {};
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> exportLigand({
    required String smiles,
    required String format,
  }) async {
    if (AppFeatureFlag.useFakeGeneration) {
      return _fakeExportLigand(smiles, format);
    }
    return safeApiCall(() async {
      final response = await dioService.post(
        endpoint: AppEndpoints.ligandsExport,
        data: {'smiles': smiles, 'format': format},
      );
      final base = BaseResponseModel<Map<String, dynamic>>.fromJson(
        response as Map<String, dynamic>,
        (d) => d as Map<String, dynamic>,
      );
      return base.data ?? {};
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> _fakeExportLigand(
    String smiles,
    String format,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right({
      'job_id': 'lig_fake_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'completed',
      'format': format,
      'filename': 'ligand_3d.$format',
      'smiles': smiles,
      'download_url':
          'https://shdwrow-ailixir-generation.hf.space/files/jobs/lig_fake/ligand_3d.$format',
    });
  }

  Future<Either<Failure, GenerationJobEntity>> _fakeSubmitJob() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      GenerationJobEntity(
        jobId: 'fake-job-${DateTime.now().millisecondsSinceEpoch}',
        status: 'submitted',
        numMolecules: 10,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<Either<Failure, GenerationJobEntity>> _fakeGetJobStatus(
    String jobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(
      GenerationJobEntity(
        jobId: jobId,
        status: 'completed',
        numMolecules: 10,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> _fakeCancelJob(
    String jobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right({'job_id': jobId, 'status': 'cancelled'});
  }

  Future<Either<Failure, GenerationResultEntity>> _fakeGetJobResults(
    String jobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      GenerationResultEntity(
        jobId: jobId,
        status: 'completed',
        summary: GenerationSummaryEntity(
          numRequested: 10,
          numGenerated: 3,
          numValid: 3,
          numReturned: 3,
          numDocked: 0,
        ),
        ligands: LigandEntity.createFakeData(),
        createdAt: DateTime.now(),
      ),
    );
  }
}
