import 'package:ailixir/features/auth/data/model/user/user_model.dart';

/// Payload returned by login and verify-email:
/// { "token": "...", "user": { ... } }
class AuthTokenUserResponse {
  final String token;
  final UserModel user;

  const AuthTokenUserResponse({required this.token, required this.user});

  factory AuthTokenUserResponse.fromJson(Map<String, dynamic> json) {
    return AuthTokenUserResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
