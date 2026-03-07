class AwardModel {
  final int id;
  final String name;
  final String category;
  final String shortDesc;
  final String imageUrl;
  final String? yearWon;
  const AwardModel({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDesc,
    required this.imageUrl,
    this.yearWon,
  });
  const AwardModel.defaultAward({
    this.id = -1,
    this.shortDesc = "desc",
    this.category = "category",
    this.imageUrl = "",
    this.name = "name",
    this.yearWon = "2002",
  });
}
