class BaseResponseModel<T> {
  final bool success;
  final String message;
  final T? data;

  BaseResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) createData,
  ) {
    return BaseResponseModel<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Error happened Can\'t connect to the API',
      data: json['data'] != null ? createData(json['data']) : null,
    );
  }
}
