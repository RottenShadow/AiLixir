class ScientistModel {
  final String name;
  final int id;
  final String imageUrl;
  final String field;
  final String shortBio;
  final String? yearWon;
  const ScientistModel({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.shortBio,
    required this.field,
    this.yearWon,
  });
  const ScientistModel.defaultScientist({
    this.name = "DEFAULT_NAME",
    this.id = -1,
    this.imageUrl = "",
    this.shortBio = "SHORT_BIO",
    this.field = "FIELD",
    this.yearWon = "2026",
  });
}
