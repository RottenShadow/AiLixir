import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ailixir/core/services/api/dio_interceptor.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';

class DioService {
  final Dio dio;
  final LocalAuthDataSource localAuthDataSource;

  DioService({required this.dio, required this.localAuthDataSource});

  void init() async {
    // TODO: remove this when we get the real certificate
    // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    //   final client = HttpClient();
    //   client.badCertificateCallback = (cert, host, port) => true;
    //   return client;
    // };
    dio.interceptors.addAll([
      DioInterceptors(client: dio, localAuthDataSource: localAuthDataSource),
      PrettyDioLogger(),
    ]);
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    var res = await dio.get(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
    return res.data;
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    var res = await dio.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
    return res.data;
  }

  Future<Map<String, dynamic>> patch({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    var res = await dio.patch(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
    return res.data;
  }

  Future delete({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    var res = await dio.delete(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
    return res.data;
  }

  static Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final Map<String, dynamic> map = {};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      // 🔹 XFile
      if (value is XFile) {
        map[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.name,
        );
        map['${key}_path'] = value.path;
      }
      // 🔹 File
      else if (value is File) {
        map[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
        map['${key}_path'] = value.path;
      }
      // 🔹 List<XFile>
      else if (value is List<XFile>) {
        map[key] = await Future.wait(
          value.map(
            (file) => MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
        map['${key}_path'] = value.map((f) => f.path).join(',');
      }
      // 🔹 List<File>
      else if (value is List<File>) {
        map[key] = await Future.wait(
          value.map(
            (file) => MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
        map['${key}_path'] = value.map((f) => f.path).join(',');
      }
      // 🔹 Primitive values (bool stays bool)
      else {
        map[key] = value;
      }
    }

    return FormData.fromMap(map);
  }

  static Future<dynamic> rebuildFormDataIfNeeded(dynamic data) async {
    if (data is! FormData) return data;
    final originalFormData = data;
    final newFormData = FormData();

    for (final field in originalFormData.fields) {
      // Skip any path helper field
      if (field.key.endsWith('_path')) continue;
      newFormData.fields.add(MapEntry(field.key, field.value));
    }

    for (final file in originalFormData.files) {
      final key = file.key;
      final value = file.value;

      // Try to find stored path
      final pathField = originalFormData.fields
          .firstWhere(
            (f) => f.key == '${key}_path',
            orElse: () => const MapEntry('', ''),
          )
          .value;

      if (pathField.isNotEmpty) {
        newFormData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(
              pathField,
              filename: value.filename,
              contentType: value.contentType,
            ),
          ),
        );
      } else {
        // fallback (e.g. fromBytes)
        final bytes = await value.finalize().toList().then(
          (chunks) => chunks.expand((x) => x).toList(),
        );
        newFormData.files.add(
          MapEntry(
            key,
            MultipartFile.fromBytes(
              bytes,
              filename: value.filename,
              contentType: value.contentType,
            ),
          ),
        );
      }
    }
    return newFormData;
  }
}
