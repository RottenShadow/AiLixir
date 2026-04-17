import 'user.dart';

class AuthLoginSuccessModel {
  final String token;
  final String refreshToken;
  final User user;

  AuthLoginSuccessModel({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthLoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return AuthLoginSuccessModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
