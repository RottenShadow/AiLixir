import 'package:ailixir/features/awards/data/models/award_model.dart';

abstract class AwardFactory {
  static List<AwardModel> getAwardsFromJson(Map<String, dynamic> data) {
    if (data["success"] == false) {
      return [];
    }
    List<AwardModel> awards = [];
    for (Map<String, dynamic> result in data["data"]["results"]) {
      awards.add(
        AwardModel(
          id: result["id"],
          name: result["name"],
          category: result["category"],
          shortDesc: result["short_description"],
          imageUrl: result["images"][0],
        ),
      );
    }
    return awards;
  }

  static List<AwardModel> getAwardsFromScientistJson(
    Map<String, dynamic> data,
  ) {
    if (data["success"] == false) {
      return [];
    }
    List<AwardModel> awards = [];
    for (Map<String, dynamic> result in data["data"]["results"]) {
      awards.add(
        AwardModel(
          id: result["id"],
          name: result["name"],
          category: result["category"],
          shortDesc: result["contribution"],
          yearWon: result["year_won"],
          imageUrl: result["image"],
        ),
      );
    }
    return awards;
  }
}
