import 'package:ailixir/features/home/presentation/models/award_model.dart';

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
}
