/// Represents the `user` object returned by login and verify-email endpoints.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final String? updatedAt;
  final bool? isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.updatedAt,
    this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] ?? json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'normal',
      avatar: json['avatar'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'avatar': avatar,
    'updated_at': updatedAt,
    'is_verified': isVerified,
  };

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, role: $role, avatar: $avatar, updatedAt: $updatedAt, isVerified: $isVerified)';
}
