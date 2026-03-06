// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:ailixir/core/errors/api/api_email_unverified.dart';
// import 'package:ailixir/core/services/api/app_endpoints.dart';
// import 'package:ailixir/core/errors/failure.dart';
// import 'package:ailixir/core/services/api/dio_service.dart';
// import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
// import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
// import 'package:ailixir/features/auth/data/data_source/remote_auth_data_source.dart';
// import 'package:ailixir/features/auth/data/model/signup_input_details_model.dart';

// class AuthRepoImpl {
//   final LocalAuthDataSource localAuthDataSource;
//   final RemoteAuthDataSource remoteAuthDataSource;
//   final DioService dioService;

//   AuthRepoImpl({
//     required this.localAuthDataSource,
//     required this.remoteAuthDataSource,
//     required this.dioService,
//   });

//   Future<Either<Failure, String>> signUpWithEmailAndPassword({
//     required SignupInputDetailsModel signupInputDetailsModel,
//   }) => safeApiCall(() async {
//     var data = await signupInputDetailsModel.toJson();
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authSignUp,
//       data: data,
//     );
//     return res['message'] ?? 'Success';
//   });

//   Future<Either<Failure, String>> loginWithPassword({
//     required String identifier,
//     required String password,
//   }) => safeApiCall(() async {
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authLogin,
//       data: {'identifier': identifier, 'password': password},
//     );

//     final unverified = remoteAuthDataSource.getLoginUserNeedVerificationData(
//       req: res,
//     );
//     if (unverified.needsVerification) {
//       await resendVerificationOtp(identifier: identifier);
//       throw AuthEmailUnverified(
//         email: unverified.email,
//         message: unverified.message,
//       );
//     }

//     var msg = await _saveUserDataFromResponse(res);
//     return msg;
//   });

//   Future<Either<Failure, String>> completeLogin({
//     required String identifier,
//     required String otp,
//   }) => safeApiCall(() async {
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authCompleteLoginOtp,
//       data: {'email': identifier, 'otp': otp},
//     );
//     return await _saveUserDataFromResponse(res);
//   });

//   Future<Either<Failure, String>> resendVerificationOtp({
//     required String identifier,
//   }) => safeApiCall(() async {
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authResendVerificationOtp,
//       data: {'email': identifier},
//     );
//     return res['message'] ?? 'OTP Resent Successfully';
//   });

//   Future<Either<Failure, String>> forgotPassword({
//     required String identifier,
//   }) => safeApiCall(() async {
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authForgotPassword,
//       data: {'email': identifier},
//     );
//     return res['message'] ?? 'Success';
//   });

//   Future<Either<Failure, String>> verifyPasswordOtp({
//     required String identifier,
//     required String otp,
//   }) => safeApiCall(() async {
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authVerifyPasswordOtp,
//       data: {'email': identifier, 'otp': otp},
//     );

//     final token = remoteAuthDataSource.getForgotPasswordUserToken(req: res);
//     await localAuthDataSource.updateUserAccessToken(token: token);

//     return res['message'] ?? 'Success';
//   });

//   Future<Either<Failure, String>> resetPassword({
//     required String password,
//     required String confirmPassword,
//   }) => safeApiCall(() async {
//     final token = await localAuthDataSource.getUserToken() ?? '';
//     final res = await dioService.post(
//       endpoint: AppEndpoints.authResetPassword,
//       data: {
//         'newPassword': password,
//         'confirmPassword': confirmPassword,
//         'token': token,
//       },
//     );
//     return res['message'] ?? 'Success';
//   });

//   Future<String> forceLogout() async {
//     await safeApiCall(() async {
//       await dioService.post(endpoint: AppEndpoints.authLogout);
//     });
//     await localAuthDataSource.clearUserTokensAndData();
//     var msg = 'Logged out successfully';
//     return msg;
//   }

//   Future<String> _saveUserDataFromResponse(
//     Map<String, dynamic> response,
//   ) async {
//     final res = remoteAuthDataSource.getUserSuccessDataFromApi(req: response);
//     await localAuthDataSource.saveAllUserData(authLoginSuccessModel: res.data!);
//     log('User Data Saved: ${res.data?.user.displayName}');
//     return res.message;
//   }
// }
