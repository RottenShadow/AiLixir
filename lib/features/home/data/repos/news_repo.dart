import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/home/domain/entities/news_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class NewsRepo {
  final DioService dioService = GetIt.I.get<DioService>();
  int _page = 1;
  //int _bpage = 1;

  Future<Either<Failure, List<NewsEntity>>> getBookmarks() {
    if (AppFeatureFlag.useFakeNews) {
      return _fakeGetBookmarks();
    }
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}news/saved",
      );
      List<NewsEntity> res = [];
      for (Map<String, dynamic> article in json["data"]["results"]) {
        res.add(NewsEntity.fromBookmarkJson(json: article));
      }
      return res;
    });
  }

  Future<Either<Failure, List<NewsEntity>>> getNews() {
    if (AppFeatureFlag.useFakeNews) {
      return _fakeGetNews();
    }
    return safeApiCall(() async {
      if (_page == 1) {
        // Map<String, dynamic> res = await dioService.get(
        //   endpoint: "${AppEndpoints.baseUrl}news/refresh",
        // );
        // if (!res["success"]) {
        //  throw Exception("Failed to refresh news");
        // }
      }
      Map<String, dynamic> json = await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}news?page=$_page&per_page=10",
      );
      if (!json["success"]) {
        throw Exception("Server Error");
      }
      List<NewsEntity> res = [];
      for (Map<String, dynamic> article in json["data"]["results"]) {
        res.add(NewsEntity.fromJson(json: article));
      }
      _page += 1;
      return res;
    });
  }

  Future<Either<Failure, bool>> saveBookmark(int articleID) {
    if (AppFeatureFlag.useFakeNews) {
      return _fakeSaveBookmark(articleID);
    }
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}news/$articleID/save",
      );
      return json["success"];
    });
  }

  Future<Either<Failure, bool>> removeBookmark(int articleID) {
    if (AppFeatureFlag.useFakeNews) {
      return _fakeRemoveBookmark(articleID);
    }
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.delete(
        endpoint: "${AppEndpoints.baseUrl}news/saved/$articleID",
      );
      return json["success"];
    });
  }

  // ── Fake helpers ────────────────────────────────────────────────────────

  Future<Either<Failure, List<NewsEntity>>> _fakeGetNews() async {
    await Future.delayed(const Duration(milliseconds: 33));
    return Right(NewsEntity.getTestData);
  }

  Future<Either<Failure, List<NewsEntity>>> _fakeGetBookmarks() async {
    await Future.delayed(const Duration(milliseconds: 33));
    return Right([]);
  }

  Future<Either<Failure, bool>> _fakeSaveBookmark(int articleID) async {
    await Future.delayed(const Duration(milliseconds: 33));
    return const Right(true);
  }

  Future<Either<Failure, bool>> _fakeRemoveBookmark(int articleID) async {
    await Future.delayed(const Duration(milliseconds: 33));
    return const Right(true);
  }
}
