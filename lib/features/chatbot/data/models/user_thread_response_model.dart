class UserThreadResponseModel {
  final int id;
  final String thread_id;
  const UserThreadResponseModel({required this.id, required this.thread_id});

  UserThreadResponseModel.fromJson(Map<String, dynamic> json)
    : this(id: json["id"], thread_id: json["thread_id"]);
}
