import 'dart:developer';

import 'package:ailixir/core/errors/social_auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/data/data_source/remote_auth_data_source.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

class SocialAuthRepoImpl {
  final LocalAuthDataSource localAuthDataSource;
  final RemoteAuthDataSource remoteAuthDataSource;
  final DioService dioService;

  bool _isGoogleSigninInit = false;
  late GoogleSignIn googleSignIn;

  SocialAuthRepoImpl({
    required this.localAuthDataSource,
    required this.remoteAuthDataSource,
    required this.dioService,
  });

  Future<Either<Failure, String>> signInWithGoogle() => safeApiCall(() async {
    String token = '';

    try {
      if (!_isGoogleSigninInit) {
        final clientId = dotenv.env['GOOGLE_CLIENT_ID'];
        final clientSecret = dotenv.env['GOOGLE_CLIENT_SECRET'];
        final scopes = ['openid', 'email', 'profile'];
        googleSignIn = GoogleSignIn(
          params: GoogleSignInParams(
            clientId: clientId,
            clientSecret: clientSecret,
            scopes: scopes,
          ),
        );
        _isGoogleSigninInit = true;
      }
      var auth = await googleSignIn.signIn();
      log('auth: ${auth?.accessToken}');
      token = auth!.accessToken;
      log('google access token: $token');
    } catch (e) {
      // Workaround for Google Sign In Failure
      log('e: $e');
      throw SocialAuthFailure(
        message: 'Login with Google Failed \n Please Try Again Later!',
      );
    }

    final res = await dioService.post(
      endpoint: AppEndpoints.authGoogle,
      data: {'access_token': token},
    );

    return await _saveUserDataFromResponse(res);
  });

  Future<String> forceLogout() async {
    await safeApiCall(() async {
      await dioService.post(endpoint: AppEndpoints.authLogout);
    });
    await localAuthDataSource.clearUserTokensAndData();
    var msg = 'Logged out successfully';
    return msg;
  }

  Future<String> _saveUserDataFromResponse(
    Map<String, dynamic> response,
  ) async {
    final res = remoteAuthDataSource.getUserSuccessDataFromApi(req: response);
    await localAuthDataSource.saveAllUserData(authLoginSuccessModel: res.data!);
    log('User Data Saved: ${res.data?.user.displayName}');
    return res.message;
  }
}
