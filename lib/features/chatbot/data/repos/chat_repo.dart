import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/chatbot/data/models/thread_message_model.dart';
import 'package:ailixir/features/chatbot/data/models/thread_model.dart';
import 'package:ailixir/features/chatbot/data/models/user_thread_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class ChatRepo {
  final DioService dioService = GetIt.I.get<DioService>();
  Future<Either<Failure, List<ThreadModel>>> getUserThreads() {
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.get(
        endpoint: "${AppEndpoints.baseUrl}chemistry/threads",
      );
      if (!json["success"]) {
        throw Exception("Server Error");
      }
      if ((json["data"]).isEmpty) {
        json = ((await dioService.post(
          endpoint: "${AppEndpoints.baseUrl}chemistry/thread",
        )));
        if (!json["success"]) {
          throw Exception("Server Error");
        }
        json = json["data"];
        return [ThreadModel(id: json["thread_id"], title: "New Conversation")];
      }

      return List.generate(json["data"].length, (idx) {
        return ThreadModel.fromJson(json["data"][idx]);
      });
    });
  }

  Future<Either<Failure, ThreadModel>> newThread() {
    return safeApiCall(() async {
      Map<String, dynamic> json = ((await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}chemistry/thread",
      )));

      if (!json["success"]) {
        throw Exception("Server Error");
      }

      json = json["data"];

      return ThreadModel(id: json["thread_id"], title: "New Conversation");
    });
  }

  Future<Either<Failure, ThreadMessageModel>> getThreadHistory(
    String thread_id,
  ) {
    return safeApiCall(() async {
      Map<String, dynamic> json = await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}chemistry/thread-messages",
        data: {"thread_id": thread_id},
      );
      if (!json["success"]) {
        throw Exception("Server Error");
      }
      return ThreadMessageModel.fromJson(json);
    });
  }

  Future<Either<Failure, String>> sendMessage(
    String message,
    String sessionId,
  ) {
    return safeApiCall(() async {
      Map<String, dynamic> response = await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}chemistry/chat",
        data: {"message": message, "thread_id": sessionId},
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
