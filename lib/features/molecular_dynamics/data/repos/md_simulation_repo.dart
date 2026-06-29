import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/molecular_dynamics/data/models/md_job_model.dart';
import 'package:ailixir/features/molecular_dynamics/domain/entities/md_job_entity.dart';

class MdSimulationRepo {
  final DioService dioService;

  MdSimulationRepo({required this.dioService});

  int _boolToInt(bool value) => value ? 1 : 0;

  /// Submit a new MD simulation job.
  /// Required: proteinPath, ligandPath (PDB files)
  /// Optional: all simulation parameters from API.md
  Future<Either<Failure, MdJobEntity>> submitJob({
    required String proteinPath,
    required String proteinName,
    required String ligandPath,
    required String ligandName,
    // Optional parameters matching API spec
    String forceField = 'ff19SB',
    int netCharge = 0,
    double boxSize = 12.0,
    String ionType = 'NaCl',
    double saltConc = 0.15,
    bool removeWaters = true,
    bool addHydrogens = true,
    double equilTimeNs = 5.0,
    double simTimeNs = 0.1,
    int nStrides = 10,
    double temperatureK = 298.0,
    double pressureBar = 1.0,
    int dtFs = 2,
  }) async {
    if (AppFeatureFlag.useFakeMdSimulation) {
      return _fakeSubmitJob();
    }

    return safeApiCall(() async {
      final formData = FormData.fromMap({
        'protein': await MultipartFile.fromFile(
          proteinPath,
          filename: proteinName,
        ),
        'ligand': await MultipartFile.fromFile(
          ligandPath,
          filename: ligandName,
        ),
        'force_field': forceField,
        'net_charge': netCharge.toString(),
        'box_size': boxSize.toString(),
        'ion_type': ionType,
        'salt_conc': saltConc.toString(),
        'remove_waters': _boolToInt(removeWaters),
        'add_hydrogens': _boolToInt(addHydrogens),
        'equil_time_ns': equilTimeNs.toString(),
        'sim_time_ns': simTimeNs.toString(),
        'n_strides': nStrides,
        'temperature_k': temperatureK.toString(),
        'pressure_bar': pressureBar.toString(),
        'dt_fs': dtFs.toString(),
      });

      final response = await dioService.post(
        endpoint: AppEndpoints.mdSimulationProcess,
        data: formData,
      );

      final base = BaseResponseModel.fromJson(
        response as Map<String, dynamic>,
        (data) => data,
      );

      return MdJobModel.fromJson(base.data as Map<String, dynamic>).toEntity();
    });
  }

  /// Poll job status
  Future<Either<Failure, MdJobEntity>> getJobStatus(String remoteJobId) async {
    if (AppFeatureFlag.useFakeMdSimulation) {
      return _fakeJobStatus(remoteJobId);
    }

    return safeApiCall(() async {
      final response = await dioService.get(
        endpoint: AppEndpoints.mdSimulationStatus(remoteJobId),
      );

      final base = BaseResponseModel.fromJson(
        response as Map<String, dynamic>,
        (data) => data,
      );

      return MdJobModel.fromJson(base.data as Map<String, dynamic>).toEntity();
    });
  }

  /// Trigger post-simulation analysis
  Future<Either<Failure, MdJobEntity>> triggerAnalysis(
    String remoteJobId, {
    String rmsdMask = '@CA',
    String ccMask = '@CA',
    int skip = 1,
    int dpi = 300,
    double threshold = 0.3,
  }) async {
    if (AppFeatureFlag.useFakeMdSimulation) {
      return _fakeJobStatus(remoteJobId);
    }

    return safeApiCall(() async {
      final response = await dioService.post(
        endpoint: AppEndpoints.mdSimulationAnalyze(remoteJobId),
        data: {
          'rmsd_mask': rmsdMask,
          'cc_mask': ccMask,
          'skip': skip,
          'dpi': dpi,
          'threshold': threshold,
        },
      );

      // Response contains download_url and outputs, wrap into a job entity
      final base = BaseResponseModel.fromJson(
        response as Map<String, dynamic>,
        (data) => data,
      );

      final data = base.data as Map<String, dynamic>;
      return MdJobEntity(
        remoteJobId: remoteJobId,
        status: 'completed',
        analysisDownloadUrl: data['download_url'] as String?,
        createdAt: DateTime.now(),
      );
    });
  }

  // ── Fake data ────────────────────────────────────────────────────────────

  Future<Either<Failure, MdJobEntity>> _fakeSubmitJob() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(
      MdJobEntity(
        remoteJobId: 'fake-${DateTime.now().millisecondsSinceEpoch}',
        status: 'processing',
        remoteStatus: 'Step 1/7 — Loading PDB files',
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<Either<Failure, MdJobEntity>> _fakeJobStatus(
    String remoteJobId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(
      MdJobEntity(
        remoteJobId: remoteJobId,
        status: 'completed',
        remoteStatus: 'Success: MD Pipeline Completed',
        protein: 'protein.pdb',
        ligand: 'ligand.pdb',
        resultDownloadUrl: '/download/$remoteJobId',
        analysisDownloadUrl: '/download_analysis/$remoteJobId',
        createdAt: DateTime.now(),
      ),
    );
  }
}
