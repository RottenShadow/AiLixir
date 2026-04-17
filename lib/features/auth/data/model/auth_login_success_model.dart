import 'package:ailixir/features/auth/data/model/auth_login_success_model/user.dart';

class AuthLoginSuccessModel {
  final String token;
  final User user;

  AuthLoginSuccessModel({required this.token, required this.user});

  factory AuthLoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return AuthLoginSuccessModel(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
