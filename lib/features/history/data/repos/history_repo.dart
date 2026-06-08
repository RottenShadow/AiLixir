import 'package:dartz/dartz.dart';
import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/ligand_details_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/core/model/base_response_model/paginated_data_model.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/history/data/models/generation_history_entry_model.dart';
import 'package:ailixir/features/history/data/models/docking_history_entry_model.dart';

class HistoryRepo {
  final DioService dioService;

  HistoryRepo({required this.dioService});

  static const _fakeSmiles = [
    'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C',
    'NC1=NC2=C(N=C(N2)C(=O)N)C(=O)N1',
    'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O',
    'O=C(O)c1ccccc1Nc1cccc(C(F)(F)F)c1',
    'CC(=O)Nc1ccc(O)cc1',
  ];

  static final _fakeLigandPool = List.generate(
    50,
    (i) => LigandEntity(
      id: '${i + 1}',
      candidateName: 'Candidate #${(812 - i).toString().padLeft(5, '0')}',
      smiles: _fakeSmiles[i % _fakeSmiles.length],
      generatedAt: DateTime.now().subtract(Duration(hours: i * 3 + 1)),
    ),
  );

  static final _fakeDockingTargets = [
    ('6LU7', 'SARS-CoV-2 Mpro', -10.4),
    ('1AKI', 'Lysozyme', -9.8),
    ('3N75', 'BACE1', -8.5),
    ('4HHB', 'Hemoglobin', -7.9),
    ('2HHB', 'Deoxyhemoglobin', -8.1),
    ('1HSG', 'HIV Protease', -11.2),
    ('3PTB', 'Trypsin', -7.3),
    ('1ATP', 'cAMP-dependent PK', -9.1),
  ];

  static final _fakeDockingPool = List.generate(40, (i) {
    final t = _fakeDockingTargets[i % _fakeDockingTargets.length];
    return DockingEntity(
      id: '${i + 1}',
      targetId: t.$1,
      targetName: t.$2,
      jobId: 'JOB-${1000 + i}-${44000 + i * 7}',
      createdAt: DateTime.now().subtract(Duration(days: i + 1)),
      vinaScore: t.$3 - (i % 3) * 0.3,
    );
  });

  static final _fakeMdTasks = [
    ('ACE2_spike_interaction', 'AMBER1\n4SB', '100 ns', MdStatus.completed),
    ('B-DNA_solvated_box', 'CHARMM\n36m', '50 ns', MdStatus.completed),
    ('Protein_folding_run', 'GROMOS\n54A7', '200 ns', MdStatus.running),
    ('Membrane_bilayer_sim', 'OPLS-AA', '75 ns', MdStatus.completed),
    ('Ligand_binding_free_energy', 'AMBER\nff14SB', '500 ns', MdStatus.failed),
    ('RNA_duplex_dynamics', 'CHARMM\n36', '150 ns', MdStatus.completed),
  ];

  static final _fakeMdPool = List.generate(36, (i) {
    final t = _fakeMdTasks[i % _fakeMdTasks.length];
    return MdEntity(
      id: '${i + 1}',
      simulationTask: '${t.$1}_${i + 1}',
      createdAt: DateTime(2023, 10, 24).subtract(Duration(days: i)),
      forcefield: t.$2,
      duration: t.$3,
      status: t.$4,
    );
  });

  Future<Either<Failure, PaginatedData<LigandEntity>>> getGenerationHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    if (AppFeatureFlag.useFakeHistory) {
      return _fakeGenerationHistory(page, perPage);
    }
    return safeApiCall(() async {
      final response = await dioService.get(
        endpoint: AppEndpoints.aiJobHistory,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final json = response as Map<String, dynamic>;
      final dataList = (json['data'] as List<dynamic>?)
              ?.map((e) => GenerationHistoryEntryModel.fromJson(
                    e as Map<String, dynamic>,
                  ).toEntity())
              .toList() ??
          [];

      final meta = json['meta'] as Map<String, dynamic>? ?? {};
      final rawPagination =
          meta['pagination'] as Map<String, dynamic>? ?? {};

      final currentPage = rawPagination['current_page'] as num? ?? 1;
      final lastPage = rawPagination['last_page'] as num? ?? 1;
      final total = rawPagination['total'] as num? ?? 0;
      final pagination = PaginationModel(
        currentPage: currentPage.toInt(),
        totalPages: lastPage.toInt(),
        totalResults: total.toInt(),
        hasNextPage: currentPage.toInt() < lastPage.toInt(),
        hasPrevPage: currentPage.toInt() > 1,
      );

      return PaginatedDataWithExtra<LigandEntity, dynamic>(
        results: dataList,
        pagination: pagination,
      );
    });
  }

  Future<Either<Failure, PaginatedData<DockingEntity>>> getDockingHistory({
    int page = 1,
    int perPage = 15,
  }) async {
    if (AppFeatureFlag.useFakeHistory) {
      return _fakeDockingHistory(page, perPage);
    }
    return safeApiCall(() async {
      final response = await dioService.get(
        endpoint: AppEndpoints.dockingHistory,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final base = BaseResponseModel.fromJson(
        response as Map<String, dynamic>,
        (data) => data,
      );

      final innerData = base.data as Map<String, dynamic>;

      final items = (innerData['data'] as List<dynamic>?)
              ?.map((e) => DockingHistoryEntryModel.fromJson(
                    e as Map<String, dynamic>,
                  ).toEntity())
              .toList() ??
          [];

      final rawPagination =
          innerData['pagination'] as Map<String, dynamic>? ?? {};

      final currentPage = rawPagination['current_page'] as num? ?? 1;
      final lastPage = rawPagination['last_page'] as num? ?? 1;
      final total = rawPagination['total'] as num? ?? 0;
      final hasMore = rawPagination['has_more'] as bool? ?? false;

      final pagination = PaginationModel(
        currentPage: currentPage.toInt(),
        totalPages: lastPage.toInt(),
        totalResults: total.toInt(),
        hasNextPage: hasMore,
        hasPrevPage: currentPage.toInt() > 1,
      );

      return PaginatedDataWithExtra<DockingEntity, dynamic>(
        results: items,
        pagination: pagination,
      );
    });
  }

  Future<Either<Failure, LigandDetailsEntity>> getLigandDetails(
    String ligandId,
  ) async {
    if (AppFeatureFlag.useFakeHistory) {
      await Future.delayed(const Duration(milliseconds: 1500));
      return Right(LigandDetailsEntity.createFakeData(ligandId));
    }
    return safeApiCall(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return LigandDetailsEntity.createFakeData(ligandId);
    });
  }

  Future<Either<Failure, PaginatedData<MdEntity>>> getMdHistory({
    int page = 1,
    int perPage = 15,
  }) async {
    if (AppFeatureFlag.useFakeHistory) {
      return _fakeMdHistory(page, perPage);
    }
    return Right(
      PaginatedDataWithExtra<MdEntity, dynamic>(
        results: [],
        pagination: PaginationModel(
          currentPage: 1,
          totalPages: 1,
          totalResults: 0,
          hasNextPage: false,
          hasPrevPage: false,
        ),
      ),
    );
  }

  Future<Either<Failure, PaginatedData<LigandEntity>>> _fakeGenerationHistory(
    int page,
    int perPage,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = (page - 1) * perPage;
    final items = _fakeLigandPool.skip(start).take(perPage).toList();
    final totalPages = (_fakeLigandPool.length / perPage).ceil();
    return Right(
      PaginatedDataWithExtra<LigandEntity, dynamic>(
        results: items,
        pagination: PaginationModel(
          currentPage: page,
          totalPages: totalPages,
          totalResults: _fakeLigandPool.length,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }

  Future<Either<Failure, PaginatedData<DockingEntity>>> _fakeDockingHistory(
    int page,
    int perPage,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = (page - 1) * perPage;
    final items = _fakeDockingPool.skip(start).take(perPage).toList();
    final totalPages = (_fakeDockingPool.length / perPage).ceil();
    return Right(
      PaginatedDataWithExtra<DockingEntity, dynamic>(
        results: items,
        pagination: PaginationModel(
          currentPage: page,
          totalPages: totalPages,
          totalResults: _fakeDockingPool.length,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }

  Future<Either<Failure, PaginatedData<MdEntity>>> _fakeMdHistory(
    int page,
    int perPage,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final start = (page - 1) * perPage;
    final items = _fakeMdPool.skip(start).take(perPage).toList();
    final totalPages = (_fakeMdPool.length / perPage).ceil();
    return Right(
      PaginatedDataWithExtra<MdEntity, dynamic>(
        results: items,
        pagination: PaginationModel(
          currentPage: page,
          totalPages: totalPages,
          totalResults: _fakeMdPool.length,
          hasNextPage: page < totalPages,
          hasPrevPage: page > 1,
        ),
      ),
    );
  }
}
