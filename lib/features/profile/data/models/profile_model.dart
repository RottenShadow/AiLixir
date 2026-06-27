//class ProfileModel {
//  final int id;
//  final String name;
//  final String email;
//  final String role;
//  const ProfileModel({
//    required this.id,
//    required this.name,
//    required this.email,
//    required this.role,
//  });
//  ProfileModel.fromJson(Map<String, dynamic> json)
//    : this(
//        id: json["data"]["id"],
//        name: json["data"]["name"],
//        email: json["data"]["email"],
//        role: json["data"]["role"],
//      );
//}
//
class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String institution;
  final String focus;
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.institution,
    required this.focus,
  });
  ProfileModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json["data"]["results"][0]["id"],
        name: json["data"]["results"][0]["name"],
        email: json["data"]["results"][0]["email"],
        institution:
            json["data"]["results"][0]["researcher"]?["university"] ?? "",
        focus:
            json["data"]["results"][0]["researcher"]?["specialization"] ?? "",
      );
}
