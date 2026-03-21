import 'package:ailixir/features/scientists/data/models/scientist_model.dart';

abstract class ScientistFactory {
  static List<ScientistModel> getScientistsFromJson(Map<String, dynamic> json) {
    if (json["success"] == false) {
      return [];
    }
    List<ScientistModel> scientists = [];
    for (Map<String, dynamic> result in json["data"]["results"]) {
      scientists.add(
        ScientistModel(
          id: result["id"],
          name: result["name"],
          field: result["field"],
          shortBio: result["short_bio"],
          imageUrl: result["images"][0],
        ),
      );
    }
    return scientists;
  }

  static List<ScientistModel> getScientistsFromAwardJson(
    Map<String, dynamic> json,
  ) {
    if (json["success"] == false) {
      return [];
    }
    List<ScientistModel> scientists = [];
    for (Map<String, dynamic> result in json["data"]["results"]) {
      scientists.add(
        ScientistModel(
          id: result["id"],
          name: result["name"],
          field: result["field"],
          shortBio: result["contribution"],
          imageUrl: result["image"],
          yearWon: result["year_won"],
        ),
      );
    }
    return scientists;
  }
}
