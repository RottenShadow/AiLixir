import 'package:dio/dio.dart';

class SignupInputDetailsModel {
  String username;
  String email;
  String password;
  String confirmPassword;
  String? displayName;

  SignupInputDetailsModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.displayName,
  });

  factory SignupInputDetailsModel.init() {
    return SignupInputDetailsModel(
      username: '',
      email: '',
      password: '',
      confirmPassword: '',
    );
  }

  void saveRequiredFields({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    this.username = username;
    this.email = email;
    this.password = password;
    this.confirmPassword = confirmPassword;
  }

  void saveOptionalFields({required String? displayName}) {
    this.displayName = displayName;
  }

  /// Convert model to JSON for API request
  Future<FormData> toJson() async {
    final data = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
    if (displayName != null && displayName!.isNotEmpty) {
      data['displayName'] = displayName;
    }
    return FormData.fromMap(data);
  }

  @override
  String toString() {
    return 'SignupInputDetailsModel(username: $username, email: $email, password: $password, confirmPassword: $confirmPassword, displayName: $displayName)';
  }
}
