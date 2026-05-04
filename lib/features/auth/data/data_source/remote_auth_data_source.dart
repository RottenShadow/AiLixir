import 'package:ailixir/core/model/base_response_model/base_response_model.dart';
import 'package:ailixir/features/auth/data/model/auth_login_need_verificatin/auth_login_need_verification_model.dart';
import 'package:ailixir/features/auth/data/model/auth_signin_response_model.dart';

class RemoteAuthDataSource {
  BaseResponseModel<AuthLoginSuccessModel> getUserSuccessDataFromApi({
    required Map<String, dynamic> req,
  }) {
    return BaseResponseModel<AuthLoginSuccessModel>.fromJson(req, (req) {
      return AuthLoginSuccessModel.fromJson(req);
    });
  }

  AuthLoginNeedVerificationModel getLoginUserNeedVerificationData({
    required Map<String, dynamic> req,
  }) {
    return AuthLoginNeedVerificationModel.fromJson(req);
  }

  String getForgotPasswordUserToken({required Map<String, dynamic> req}) {
    return req['data']['token'] ?? '';
  }
}
