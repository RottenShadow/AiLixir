import 'package:dartz/dartz.dart';
import 'package:ailixir/core/entities/docking_score_entity.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/core/entities/docking_request_entity.dart';
import 'package:ailixir/features/docking/domain/entities/docking_job_entity.dart';
import 'package:ailixir/features/docking/data/models/docking_request_model.dart';
import 'package:ailixir/features/docking/data/models/docking_job_model.dart';

class DockingRepo {
  final DioService dioService;

  DockingRepo({required this.dioService});

  Future<Either<Failure, DockingJobEntity>> submitJob(
    DockingRequestEntity request,
  ) async {
    if (AppFeatureFlag.useFakeDocking) {
      return _fakeSubmitJob();
    }
    return safeApiCall(() async {
      final formData = await DockingRequestModel.fromEntity(
        request,
      ).toFormData();
      final response = await dioService.post(
        endpoint: AppEndpoints.dockingSubmit,
        data: formData,
      );
      final base = BaseResponseModel.fromJson(
        response as Map<String, dynamic>,
        (data) => data,
      );
      return DockingJobModel.fromJson(
        base.data as Map<String, dynamic>,
      ).toEntity();
    });
  }

  Future<Either<Failure, DockingJobEntity>> getJobDetails(int jobId) async {
    if (AppFeatureFlag.useFakeDocking) {
      return _fakeGetJobDetails(jobId);
    }
    return safeApiCall(() async {
      final response = await dioService.get(
        endpoint: AppEndpoints.dockingJob(jobId),
      );
      final base = BaseResponseModel.fromJson(
        response as Map<String, dynamic>,
        (data) => data,
      );
      return DockingJobModel.fromJson(
        base.data as Map<String, dynamic>,
      ).toEntity();
    });
  }

  Future<Either<Failure, DockingJobEntity>> _fakeSubmitJob() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      DockingJobEntity(
        jobId: DateTime.now().millisecondsSinceEpoch,
        status: 'submitted',
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<Either<Failure, DockingJobEntity>> _fakeGetJobDetails(
    int jobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(
      DockingJobEntity(
        jobId: jobId,
        status: 'completed',
        inputs: DockingJobInputsEntity(
          protein: '6LU7',
          ligand: 'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C',
        ),
        results: DockingJobResultsEntity(
          scores: [
            const DockingScoreEntity(
              affinity: -10.4,
              inter: -8.802,
              intra: -0.354,
              torsions: 1.495,
              unbound: -0.354,
            ),
            const DockingScoreEntity(
              affinity: -9.2,
              inter: -8.655,
              intra: -0.258,
              torsions: 1.454,
              unbound: -0.354,
            ),
            const DockingScoreEntity(
              affinity: -8.7,
              inter: -7.924,
              intra: -0.607,
              torsions: 1.389,
              unbound: -0.354,
            ),
          ],
          downloadUrl: null,
        ),
        createdAt: DateTime.now(),
      ),
    );
  }
}
