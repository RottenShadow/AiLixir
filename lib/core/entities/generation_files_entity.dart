class GenerationFileItemEntity {
  final String filename;
  final String downloadUrl;

  const GenerationFileItemEntity({
    required this.filename,
    required this.downloadUrl,
  });
}

class GenerationFilesEntity {
  final GenerationFileItemEntity? csv;
  final GenerationFileItemEntity? json;

  const GenerationFilesEntity({this.csv, this.json});
}
