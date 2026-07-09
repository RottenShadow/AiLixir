import 'dart:developer';

import 'package:ailixir/core/errors/social_auth_failure.dart';
import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/features/auth/data/model/auth/auth_token_user_response.dart';
import 'package:dartz/dartz.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:ailixir/core/config/env/env.dart';

class SocialAuthRepoImpl {
  final LocalAuthDataSource localAuthDataSource;
  final DioService dioService;

  bool _isGoogleSigninInit = false;
  late GoogleSignIn googleSignIn;

  SocialAuthRepoImpl({
    required this.localAuthDataSource,
    required this.dioService,
  });

  Future<Either<Failure, String>> signInWithGoogle() {
    if (AppFeatureFlag.useFakeAuth) {
      return _fakeSignInWithGoogle();
    }
    return safeApiCall(() async {
      String token = '';

      try {
        if (!_isGoogleSigninInit) {
          final clientId = Env.googleClientId;
          final clientSecret = Env.googleClientSecret;
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
        var auth = await googleSignIn.signInOnline();
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
  }

  Future<String> _saveUserDataFromResponse(
    Map<String, dynamic> response,
  ) async {
    final res = BaseResponseModel<AuthTokenUserResponse>.fromJson(
      response,
      (req) => AuthTokenUserResponse.fromJson(req),
    );
    await localAuthDataSource.saveAllUserData(authTokenUserResponse: res.data!);
    log('User Data Saved: ${res.data?.user.name}');
    return res.message;
  }

  Future<Either<Failure, String>> _fakeSignInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 33));
    final res = BaseResponseModel.fromJson(
      {
        'success': true,
        'message': 'Login successful',
        'data': {
          'token': 'fake-jwt-token',
          'user': {
            'id': 1,
            'name': 'Test User',
            'email': 'test@example.com',
            'role': 'normal',
            'avatar': '',
            'updated_at': '',
            'is_verified': true,
          },
        },
      },
      (req) => AuthTokenUserResponse.fromJson(req),
    );
    await localAuthDataSource.saveAllUserData(authTokenUserResponse: res.data!);
    return Right(res.message);
  }
}
