import 'package:ailixir/core/entities/generation_files_entity.dart';

class GenerationFileItemModel {
  final String filename;
  final String downloadUrl;

  const GenerationFileItemModel({
    required this.filename,
    required this.downloadUrl,
  });

  factory GenerationFileItemModel.fromJson(Map<String, dynamic> json) {
    return GenerationFileItemModel(
      filename: json['filename'] as String? ?? '',
      downloadUrl: json['download_url'] as String? ?? '',
    );
  }

  GenerationFileItemEntity toEntity() => GenerationFileItemEntity(
    filename: filename,
    downloadUrl: downloadUrl,
  );
}

class GenerationFilesModel {
  final GenerationFileItemModel? csv;
  final GenerationFileItemModel? json;

  const GenerationFilesModel({this.csv, this.json});

  factory GenerationFilesModel.fromJson(Map<String, dynamic> json) {
    return GenerationFilesModel(
      csv: json['csv'] != null
          ? GenerationFileItemModel.fromJson(json['csv'] as Map<String, dynamic>)
          : null,
      json: json['json'] != null
          ? GenerationFileItemModel.fromJson(json['json'] as Map<String, dynamic>)
          : null,
    );
  }

  GenerationFilesEntity toEntity() => GenerationFilesEntity(
    csv: csv?.toEntity(),
    json: json?.toEntity(),
  );
}
