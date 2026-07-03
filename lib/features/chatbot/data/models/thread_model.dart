class ThreadModel {
  final String title;
  final String id;
  const ThreadModel({required this.title, required this.id});
  ThreadModel.fromJson(Map<String, dynamic> json)
    : this(title: json["title"], id: json["thread_id"]);
}
