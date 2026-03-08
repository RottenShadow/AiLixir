import 'package:ailixir/features/auth/data/repos/social_auth_repo_impl.dart';
import 'package:ailixir/features/awards/data/repos/award_repo.dart';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';
import 'package:dio/dio.dart';
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
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  GetIt.I.registerLazySingleton<DioService>(
    () =>
        DioService(dio: GetIt.I.get(), localAuthDataSource: GetIt.I.get())
          ..init(),
  );

  // My Repos

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
  // My Cubits

  GetIt.I.registerLazySingleton<AuthCubit>(() => AuthCubit());
  GetIt.I.registerLazySingleton<AwardsCubit>(() => AwardsCubit());
}
