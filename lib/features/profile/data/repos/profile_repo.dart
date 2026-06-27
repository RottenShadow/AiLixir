import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/profile/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class ProfileRepo {
  final DioService dioService = GetIt.I.get<DioService>();
  Future<Either<Failure, ProfileModel>> getProfile() {
    if (AppFeatureFlag.useFakeProfile) {
      return getTestProfile();
    }
    return safeApiCall(() async {
      return ProfileModel.fromJson(
        await dioService.get(endpoint: "${AppEndpoints.baseUrl}user/profile"),
      );
    });
  }

  Future<Either<Failure, bool>> updateProfile(
    String name,
    String institution,
    String focus,
  ) async {
    if (AppFeatureFlag.useFakeProfile) {
      await Future.delayed(Duration(milliseconds: 33));
      return Right(true);
    }
    return safeApiCall(() async {
      return (await dioService.post(
            endpoint: "${AppEndpoints.baseUrl}user/update-profile",
            data: {
              "name": name,
              "profile": {"institution": institution, "research_focus": focus},
            },
          )
          as Map<String, dynamic>)["success"];
    });
  }

  Future<Either<Failure, ProfileModel>> getTestProfile() async {
    await Future.delayed(Duration(milliseconds: 33));
    return Right<Failure, ProfileModel>(
      ProfileModel.fromJson({
        "success": true,
        "user": {
          "id": 69,
          "name": "John Pharmacist",
          "email": "johnpharm@gmail.com",
          "profile": {
            "institution": "Harvard University",
            "research_focus": "Biochemistry",
          },
        },
      }),
    );
  }
}
