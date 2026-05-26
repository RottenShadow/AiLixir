import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ailixir/core/errors/api/api_auth_user_unauthorized.dart';
import 'package:ailixir/core/errors/failure.dart';

class ApiFailure extends Failure {
  ApiFailure({required super.message});

  factory ApiFailure.fromDioError(DioException error) {
    try {
      if (error.type == DioExceptionType.connectionError ||
          (error.error is SocketException)) {
        return ApiFailure(
          message:
              'Failed to connect to the server. Please check your internet connection.',
        );
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return ApiFailure(message: 'Connection timed out. Please try again.');
      } else if (error.response?.statusCode == 204) {
        final data = error.response?.data;
        return ApiFailure(
          message:
              (data != null &&
                  data is Map<String, dynamic> &&
                  data['message'] != null)
              ? data['message']
              : 'No content available from server (204)',
        );
      } else if (error.response?.statusCode == 400) {
        return ApiFailure(
          message: error.response?.data['message'] ?? 'Unknown Error',
        );
      } else if (error.response?.statusCode == 401) {
        return ApiAuthUserUnAuthorized(
          message: error.response?.data['message'] ?? 'Unknown Error',
        );
      } else if (error.response?.statusCode == 500) {
        return ApiFailure(
          message: 'Oops! Something went wrong. Please try again.',
        );
      }

      return ApiFailure(
        message:
            error.response?.data['message'] ??
            'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      log(e.toString());
      return ApiFailure(
        message: 'Oops! Something went wrong. Please try again.',
      );
    }
  }
}
