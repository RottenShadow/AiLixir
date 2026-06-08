import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/home/domain/entities/news_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class NewsRepo {
  final DioService dioService = GetIt.I.get<DioService>();
  Future<Either<Failure, List<NewsEntity>>> getBookmarks() {
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}news/saved",
      );
      List<NewsEntity> res = [];
      for (Map<String, dynamic> article in json["results"]) {
        res.add(NewsEntity.fromJson(json: article));
      }
      return res;
    });
  }

  Future<Either<Failure, bool>> saveBookmark(String articleID) {
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}news/$articleID/save",
      );
      return json["success"];
    });
  }
}
