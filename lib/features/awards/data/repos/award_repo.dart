import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:dartz/dartz.dart';

class AwardRepo {
  final DioService dioService;
  AwardRepo({required this.dioService});

  Future<Either<Failure, Map<String, dynamic>>> getAwards({int page = 1}) {
    return safeApiCall(() async {
      return await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}awards?page=$page",
      );
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getScientists(int awardId) {
    return safeApiCall(() async {
      return await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}awards/$awardId/scientists",
      );
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getTestScientists(
    int awardId,
  ) async {
    await Future.delayed(Duration(milliseconds: 30));
    Map<String, dynamic> res = {
      "success": true,
      "data": {
        "results": [
          {
            "id": -1,
            "name": "DEFAULT_SCIENTIST",
            "field": "DEFAULT_FIELD",
            "images": [
              "https://www.allalliedhealthschools.com/wp-content/uploads/2021/02/hero-how-to-become-a-pharmacist-290x253-1.jpg",
            ],
            "nationality": "Japanese",
            "year_won": "2026",
            "contribution": "DEFAULT_CONTRIBUTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_SCIENTIST",
            "field": "DEFAULT_FIELD",
            "images": [
              "https://www.allalliedhealthschools.com/wp-content/uploads/2021/02/hero-how-to-become-a-pharmacist-290x253-1.jpg",
            ],
            "nationality": "Japanese",
            "year_won": "2026",
            "contribution": "DEFAULT_CONTRIBUTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_SCIENTIST",
            "field": "DEFAULT_FIELD",
            "images": [
              "https://www.allalliedhealthschools.com/wp-content/uploads/2021/02/hero-how-to-become-a-pharmacist-290x253-1.jpg",
            ],
            "nationality": "Japanese",
            "year_won": "2026",
            "contribution": "DEFAULT_CONTRIBUTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_SCIENTIST",
            "field": "DEFAULT_FIELD",
            "images": [
              "https://www.allalliedhealthschools.com/wp-content/uploads/2021/02/hero-how-to-become-a-pharmacist-290x253-1.jpg",
            ],
            "nationality": "Japanese",
            "year_won": "2026",
            "contribution": "DEFAULT_CONTRIBUTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_SCIENTIST",
            "field": "DEFAULT_FIELD",
            "images": [
              "https://www.allalliedhealthschools.com/wp-content/uploads/2021/02/hero-how-to-become-a-pharmacist-290x253-1.jpg",
            ],
            "nationality": "Japanese",
            "year_won": "2026",
            "contribution": "DEFAULT_CONTRIBUTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_SCIENTIST",
            "field": "DEFAULT_FIELD",
            "images": [
              "https://www.allalliedhealthschools.com/wp-content/uploads/2021/02/hero-how-to-become-a-pharmacist-290x253-1.jpg",
            ],
            "nationality": "Japanese",
            "year_won": "2026",
            "contribution": "DEFAULT_CONTRIBUTION",
          },
        ],
      },
    };
    return Right(res);
  }

  Either<Failure, Map<String, dynamic>> getTestAwards({int page = 1}) {
    Map<String, dynamic> res = {
      "success": true,
      "pagination": {
        "currentPage": page,
        "totalPages": 2,
        "hasNextPage": page >= 2,
      },
      "data": {
        "results": [
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
          {
            "id": -1,
            "name": "DEFAULT_NAME",
            "category": "DEFAULT_CATEGORY",
            "images": [""],
            "short_description": "SHORT_DESCRIPTION",
          },
        ],
      },
    };
    return Right(res);
  }
}
