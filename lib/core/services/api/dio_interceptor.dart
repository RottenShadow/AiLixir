import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';

class DioInterceptors extends Interceptor {
  final Dio client;
  final LocalAuthDataSource localAuthDataSource;

  DioInterceptors({required this.client, required this.localAuthDataSource});

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

    final token = await localAuthDataSource.getUserToken();

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

    log('ERROR[$statusCode] => PATH: ${err.requestOptions.path}');

    // Refresh request itself failed → force logout once
    if (statusCode == 401) {
      String msg = err.response?.data['message'] ?? 'Unknown error 401';
      bool shouldForceLogout = msg.toLowerCase().contains('unauthenticated');
      if (shouldForceLogout) {
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
  /// LOGOUT (ONCE)
  /// =======================
  Future<void> _forceLogoutOnce() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    log('🔒 Forcing logout (once)');

    final authCubit = GetIt.I<UserAuthCubit>();
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
