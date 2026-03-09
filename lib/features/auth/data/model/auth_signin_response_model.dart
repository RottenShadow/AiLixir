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
  String id;
  String username;
  String displayName;
  String email;
  String? avatar;
  String? bio;
  String? dateOfBirth;
  String? country;

  AuthUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.avatar,
    this.country,
    this.dateOfBirth,
    this.bio,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    displayName: json['displayName'] ?? json['username'],
    avatar: json['avatar'],
    country: json['country'],
    dateOfBirth: json['dateOfBirth'],
    bio: json['bio'],
  );
}
