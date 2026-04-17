class User {
  final String id;
  final String username;
  final String email;
  final String role;
  String? displayName;
  String? bio;
  String? country;
  DateTime? dateOfBirth;
  List profilePictureList;
  String? authProvider;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.displayName,
    this.bio,
    this.country,
    this.dateOfBirth,
    required this.profilePictureList,
    this.authProvider,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    displayName: json['displayName'] as String?,
    bio: json['bio'] as String?,
    country: json['country'] as String?,
    dateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String),
    profilePictureList: json['profilePicture'] as List,
    authProvider: json['authProvider'] as String?,
  );
}
