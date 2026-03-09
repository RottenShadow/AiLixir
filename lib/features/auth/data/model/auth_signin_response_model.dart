class AuthLoginSuccessModel {
  final String token;
  final AuthUser user;

  AuthLoginSuccessModel({required this.token, required this.user});

  factory AuthLoginSuccessModel.fromJson(Map<String, dynamic> json) {
    return AuthLoginSuccessModel(
      token: json['token'] as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class AuthUser {
  int id;
  String email;
  String name;
  String role;
  String? avatar;
  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    role: json['role'],
    avatar: json['avatar'],
  );
}
