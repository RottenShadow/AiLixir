import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/chatbot/data/models/user_thread_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class ChatRepo {
  final DioService dioService = GetIt.I.get<DioService>();
  Future<Either<Failure, String>> getUserThread(String token) {
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}chemistry/threads",
        headers: {"Authorization": "Bearer $token"},
      );
      if (!json["success"]) {
        throw Exception("Server Error");
      }
      if ((json["data"] as List<Map<String, dynamic>>).isEmpty) {
        json =
            ((await dioService.post(
                  endpoint: "${AppEndpoints.baseUrl}chemistry/thread",
                  headers: {"Authorization": "Bearer $token"},
                ))
                as Map<String, dynamic>)["data"];
      } else {
        json = json["data"][0];
      }
      return json["thread_id"];
    });
  }

  Future<Either<Failure, String>> sendMessage(String token, String message) {
    return safeApiCall(() async {
      Map<String, dynamic> response = await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}chemistry/chat",
        headers: {"Authorization": "Bearer $token"},
      );
      if (!response["success"]) throw Exception("Server Error");
      return response["data"]["reply"];
    });
  }

  Future<Either<Failure, UserThreadResponseModel>> getTestThreads(
    String token,
  ) async {
    await Future.delayed(Duration(milliseconds: 33));
    return Right<Failure, UserThreadResponseModel>(
      UserThreadResponseModel.fromJson({"id": 69, "thread_id": "hhjgjhgj"}),
    );
  }
}
