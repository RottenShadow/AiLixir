import 'package:ailixir/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ailixir/features/auth/data/repos/social_auth_repo_impl.dart';
import 'package:ailixir/features/awards/data/repos/award_repo.dart';
import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/services/local_storage/secure_storage_service.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/data/data_source/remote_auth_data_source.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

void getItRegisterSingleton() {
  // My Repos DataSource

  GetIt.I.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  GetIt.I.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSource(secureStorage: GetIt.I.get()),
  );
  GetIt.I.registerLazySingleton<RemoteAuthDataSource>(
    () => RemoteAuthDataSource(),
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

  GetIt.I.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(
      localAuthDataSource: GetIt.I.get(),
      remoteAuthDataSource: GetIt.I.get(),
      dioService: GetIt.I.get(),
    ),
  );

  GetIt.I.registerLazySingleton<SocialAuthRepoImpl>(
    () => SocialAuthRepoImpl(
      localAuthDataSource: GetIt.I.get(),
      remoteAuthDataSource: GetIt.I.get(),
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

  // My Cubits

  GetIt.I.registerLazySingleton<AuthCubit>(() => AuthCubit());
}
