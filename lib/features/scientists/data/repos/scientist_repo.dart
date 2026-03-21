import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:dartz/dartz.dart';

class ScientistRepo {
  final DioService dioService;
  ScientistRepo({required this.dioService});

  Future<Either<Failure, Map<String, dynamic>>> getAwards(int scientistId) {
    return safeApiCall(() async {
      return await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}scientists/$scientistId/awards",
      );
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getScientists() {
    return safeApiCall(() async {
      return await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}scientists",
      );
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getTestAwards(int sciId) async {
    await Future.delayed(Duration(milliseconds: 30));
    Map<String, dynamic> res = {
      "success": true,
      "data": {
        "results": [
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "image": "",
            "contribution": "DEFAULT_CONTRIBUTION",
            "year_won": "2026",
            "category": "DEFAULT_CATEGORY",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "image": "",
            "contribution": "DEFAULT_CONTRIBUTION",
            "year_won": "2026",
            "category": "DEFAULT_CATEGORY",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "image": "",
            "contribution": "DEFAULT_CONTRIBUTION",
            "year_won": "2026",
            "category": "DEFAULT_CATEGORY",
          },
        ],
      },
    };
    return Right(res);
  }

  Future<Either<Failure, Map<String, dynamic>>> getTestScientists() async {
    await Future.delayed(Duration(milliseconds: 30));
    Map<String, dynamic> res = {
      "success": true,
      "data": {
        "results": [
          {
            "id": -1,
            "name": "DEFAULT_SCI_NAME",
            "images": [
              "https://media.gettyimages.com/id/57520719/photo/doctor-holding-note-pad-posing-in-studio-portrait.jpg?s=612x612&w=0&k=20&c=cxnjilkTFucKBOneZYY6xZY7sEWTLvKLXzyWRgjJCqE=",
            ],
            "field": "DEFAULT_SCI_FIELD",
            "short_bio":
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "images": [
              "https://media.gettyimages.com/id/57520719/photo/doctor-holding-note-pad-posing-in-studio-portrait.jpg?s=612x612&w=0&k=20&c=cxnjilkTFucKBOneZYY6xZY7sEWTLvKLXzyWRgjJCqE=",
            ],
            "field": "DEFAULT_FIELD",
            "short_bio":
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "images": [
              "https://media.gettyimages.com/id/57520719/photo/doctor-holding-note-pad-posing-in-studio-portrait.jpg?s=612x612&w=0&k=20&c=cxnjilkTFucKBOneZYY6xZY7sEWTLvKLXzyWRgjJCqE=",
            ],
            "field": "DEFAULT_FIELD",
            "short_bio":
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
          },
        ],
      },
    };
    return Right(res);
  }
}
