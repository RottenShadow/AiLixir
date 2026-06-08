import 'package:ailixir/features/auth/data/repos/social_auth_repo_impl.dart';
import 'package:ailixir/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ailixir/features/auth/data/services/auth_api_service.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:ailixir/features/awards/data/repos/award_repo.dart';
import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:ailixir/features/generation/data/repos/generation_repo.dart';
import 'package:ailixir/features/docking/data/repos/docking_repo.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:ailixir/features/admet/data/repos/admet_repo.dart';
import 'package:ailixir/features/chemical_search/data/repos/chemical_search_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/services/local_storage/secure_storage_service.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';

void getItRegisterSingleton() {
  // My Repos DataSource

  GetIt.I.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  GetIt.I.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSource(secureStorage: GetIt.I.get()),
  );

  // My Services

  GetIt.I.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3),
      ),
    ),
  );

  GetIt.I.registerLazySingleton<DioService>(
    () =>
        DioService(dio: GetIt.I.get(), localAuthDataSource: GetIt.I.get())
          ..init(),
  );

  // My Repos

  GetIt.I.registerLazySingleton<AuthApiService>(
    () => AuthApiService(dioService: GetIt.I.get()),
  );

  GetIt.I.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(
      authApiService: GetIt.I.get(),
      localAuthDataSource: GetIt.I.get(),
    ),
  );

  GetIt.I.registerLazySingleton<SocialAuthRepoImpl>(
    () => SocialAuthRepoImpl(
      localAuthDataSource: GetIt.I.get(),
      dioService: GetIt.I.get(),
    ),
  );

  GetIt.I.registerLazySingleton<AwardRepo>(
    () => AwardRepo(dioService: GetIt.I.get()),
  );

  // Drug Repurposing uses its own Dio instance pointing at the HuggingFace API
  GetIt.I.registerLazySingleton<DrugRepurposingRepository>(() {
    final drugDio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.drugRepurposingBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 60),
      ),
    );
    final drugDioService = DioService(
      dio: drugDio,
      localAuthDataSource: GetIt.I.get(),
      forcedToken: dotenv.env['HF_TOKEN'],
    )..init();
    return DrugRepurposingRepository(dio: drugDioService);
  });

  GetIt.I.registerLazySingleton<GenerationRepo>(
    () => GenerationRepo(dioService: GetIt.I.get()),
  );

  GetIt.I.registerLazySingleton<DockingRepo>(
    () => DockingRepo(dioService: GetIt.I.get()),
  );

  GetIt.I.registerLazySingleton<HistoryRepo>(
    () => HistoryRepo(dioService: GetIt.I.get()),
  );

  GetIt.I.registerLazySingleton<AdmetRepo>(
    () => AdmetRepo(dioService: GetIt.I.get()),
  );

  GetIt.I.registerLazySingleton<ChemicalSearchRepo>(
    () => ChemicalSearchRepo(dioService: GetIt.I.get()),
  );

  // My Cubits

  GetIt.I.registerLazySingleton<UserAuthCubit>(() => UserAuthCubit());
}
