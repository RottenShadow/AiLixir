class AuthLoginNeedVerificationModel {
  final bool success;
  final String message;
  final bool needsVerification;
  final String email;

  AuthLoginNeedVerificationModel({
    required this.success,
    required this.message,
    required this.needsVerification,
    required this.email,
  });

  factory AuthLoginNeedVerificationModel.fromJson(Map<String, dynamic> json) {
    return AuthLoginNeedVerificationModel(
      success: json['success'],
      message: json['message'],
      needsVerification: json['needsVerification'] ?? false,
      email: json['email'] ?? '',
    );
  }
}
