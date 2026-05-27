/// Payload returned by register, forgot-password, and resend-verification:
/// { "email": "..." }
class AuthEmailResponse {
  final String email;

  const AuthEmailResponse({required this.email});

  factory AuthEmailResponse.fromJson(Map<String, dynamic> json) {
    return AuthEmailResponse(email: json['email'] as String);
  }
}
