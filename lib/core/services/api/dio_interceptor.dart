import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/core/constants/app_constants.dart';
// import 'package:ailixir/core/services/api/app_endpoints.dart';
// import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

class DioInterceptors extends Interceptor {
  final Dio client;
  final LocalAuthDataSource localAuthDataSource;
  final String? forcedToken;

  DioInterceptors({
    required this.client,
    required this.localAuthDataSource,
    this.forcedToken,
  });

  // TODO: Refactor this shit

  /// ===== GLOBAL LOCKS =====
  static bool _isLoggingOut = false;
  // static final bool _isRefreshing = false;
  // static Completer<void>? _refreshCompleter;

  /// =======================

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isLoggingOut) {
      return handler.next(options);
    }

    if (options.extra['refresh'] == true) {
      return handler.next(options);
    }

    final token = forcedToken ?? await localAuthDataSource.getUserToken();

    if (token != null) {
      options.headers[HttpHeaders.authorizationHeader] =
          '${AppConstants.bearer}$token';
      log('Token: $token');
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isLoggingOut) {
      return handler.next(err);
    }

    final statusCode = err.response?.statusCode;
    final isRefreshRequest = err.requestOptions.extra['refresh'] == true;

    log('ERROR[$statusCode] => PATH: ${err.requestOptions.path}');

    // Refresh request itself failed → force logout once
    if (statusCode == 401 && isRefreshRequest) {
      if (forcedToken == null) {
        await _forceLogoutOnce();
      }
      return handler.next(err);
    }

    // // Access token expired → try refresh
    // if (statusCode == 401 && !isRefreshRequest) {
    //   final refreshToken = await localAuthDataSource.getUserRefreshToken();

    //   if (refreshToken == null) {
    //     // await _forceLogoutOnce();
    //     return handler.next(err);
    //   }

    //   final refreshed = await _refreshTokenOnce(refreshToken);

    //   if (refreshed) {
    //     try {
    //       final response = await _retry(err.requestOptions);
    //       return handler.resolve(response);
    //     } catch (e) {
    //       return handler.next(err);
    //     }
    //   }

    //   await _forceLogoutOnce();
    // }

    handler.next(err);
  }

  /// =======================
  /// REFRESH TOKEN (ONCE)
  /// =======================
  // Future<bool> _refreshTokenOnce(String refreshToken) async {
  //   if (_isRefreshing) {
  //     await _refreshCompleter?.future;
  //     return await localAuthDataSource.getUserToken() != null;
  //   }

  //   _isRefreshing = true;
  //   _refreshCompleter = Completer<void>();

  //   try {
  //     final res = await client.post(
  //       AppEndpoints.authRefreshToken,
  //       options: Options(
  //         headers: {
  //           HttpHeaders.authorizationHeader:
  //               '${AppConstants.bearer}$refreshToken',
  //         },
  //         extra: {'refresh': true},
  //       ),
  //     );

  //     if (res.statusCode == 200) {
  //       final data = res.data['data'];

  //       await localAuthDataSource.saveUserTokens(
  //         token: data['token'],
  //         refreshToken: data['refreshToken'],
  //       );

  //       return true;
  //     }

  //     return false;
  //   } catch (e, st) {
  //     log('Refresh failed: $e\n$st');
  //     return false;
  //   } finally {
  //     _isRefreshing = false;
  //     _refreshCompleter?.complete();
  //     _refreshCompleter = null;
  //   }
  // }

  /// =======================
  /// LOGOUT (ONCE)
  /// =======================
  Future<void> _forceLogoutOnce() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    log('🔒 Forcing logout (once)');

    final authCubit = GetIt.I<AuthCubit>();
    await authCubit.forceLogout();
    _isLoggingOut = false;
  }

  // /// =======================
  // /// RETRY REQUEST
  // /// =======================
  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   final token = await localAuthDataSource.getUserToken();

  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: {
  //       ...requestOptions.headers,
  //       if (token != null)
  //         HttpHeaders.authorizationHeader: '${AppConstants.bearer}$token',
  //     },
  //   );

  //   final data = await DioService.rebuildFormDataIfNeeded(requestOptions.data);

  //   return client.request(
  //     requestOptions.path,
  //     data: data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }
}
