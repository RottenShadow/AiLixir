import 'dart:convert';

import 'package:ailixir/features/scientists/presentation/models/scientist_model.dart';

abstract class ScientistFactory {
  static List<ScientistModel> getAwardsFromJson(String json) {
    JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> sciJsonObj = decoder.convert(json);
    if (sciJsonObj["success"] == false) {
      return [];
    }
    List<ScientistModel> scientists = [];
    for (Map<String, dynamic> result in sciJsonObj["results"]) {
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
}
