import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/profile/data/models/profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class ProfileRepo {
  final DioService dioService = GetIt.I.get<DioService>();
  Future<Either<Failure, ProfileModel>> getProfile(String token) {
    return safeApiCall(() async {
      return ProfileModel.fromJson(
        await dioService.get(
          endpoint: "${AppEndpoints.baseUrl}user/profile",
          headers: {"Authorization": "Bearer $token"},
        ),
      );
    });
  }

  Future<Either<Failure, ProfileModel>> getTestProfile(String token) async {
    await Future.delayed(Duration(milliseconds: 33));
    return Right<Failure, ProfileModel>(
      ProfileModel.fromJson({
        "success": true,
        "data": {
          "id": 69,
          "name": "John Pharmacist",
          "email": "johnpharm@gmail.com",
          "role": "normal",
        },
      }),
    );
  }
}
