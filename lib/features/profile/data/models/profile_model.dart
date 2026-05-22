class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String role;
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
  ProfileModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json["data"]["id"],
        name: json["data"]["name"],
        email: json["data"]["email"],
        role: json["data"]["role"],
      );
}
