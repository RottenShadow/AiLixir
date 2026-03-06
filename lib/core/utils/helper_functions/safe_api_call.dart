import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ailixir/core/errors/api/api_failure.dart';
import 'package:ailixir/core/errors/failure.dart';

Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return Right(result);
  } catch (e) {
    if (e is DioException) {
      return Left(ApiFailure.fromDioError(e));
    }
    return Left(e is Failure ? e : Failure(message: e.toString()));
  }
}
