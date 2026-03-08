import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:dartz/dartz.dart';

class AwardRepo {
  final DioService dioService;
  AwardRepo({required this.dioService});

  Future<Either<Failure, Map<String, dynamic>>> getAwards() {
    return safeApiCall(() async {
      return await dioService.get(endpoint: "${AppEndpoints.baseUrl}awards/");
    });
  }

  Either<Failure, Map<String, dynamic>> getTestAwards() {
    Map<String, dynamic> res = {
      "success": true,
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
        ],
      },
    };
    return Right(res);
  }
}
