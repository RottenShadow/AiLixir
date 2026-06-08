import 'package:dio/dio.dart';
import 'package:ailixir/core/entities/docking_request_entity.dart';

class DockingRequestModel {
  final String? proteinFilePath;
  final String? proteinFileName;
  final String? ligandFilePath;
  final String? ligandFileName;
  final double centerX;
  final double centerY;
  final double centerZ;
  final double sizeX;
  final double sizeY;
  final double sizeZ;
  final double exhaustiveness;

  const DockingRequestModel({
    this.proteinFilePath,
    this.proteinFileName,
    this.ligandFilePath,
    this.ligandFileName,
    required this.centerX,
    required this.centerY,
    required this.centerZ,
    required this.sizeX,
    required this.sizeY,
    required this.sizeZ,
    required this.exhaustiveness,
  });

  factory DockingRequestModel.fromEntity(DockingRequestEntity entity) {
    return DockingRequestModel(
      proteinFilePath: entity.proteinFilePath,
      proteinFileName: entity.proteinFileName,
      ligandFilePath: entity.ligandFilePath,
      ligandFileName: entity.ligandFileName,
      centerX: entity.centerX,
      centerY: entity.centerY,
      centerZ: entity.centerZ,
      sizeX: entity.sizeX,
      sizeY: entity.sizeY,
      sizeZ: entity.sizeZ,
      exhaustiveness: entity.exhaustiveness,
    );
  }

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    if (proteinFilePath != null && proteinFileName != null) {
      map['protein_file'] = await MultipartFile.fromFile(
        proteinFilePath!,
        filename: proteinFileName,
      );
    }

    if (ligandFilePath != null && ligandFileName != null) {
      map['ligand_file'] = await MultipartFile.fromFile(
        ligandFilePath!,
        filename: ligandFileName,
      );
    }

    map['center_x'] = centerX;
    map['center_y'] = centerY;
    map['center_z'] = centerZ;
    map['box_size_x'] = sizeX;
    map['box_size_y'] = sizeY;
    map['box_size_z'] = sizeZ;
    map['exhaustiveness'] = exhaustiveness;

    if (proteinFileName != null) {
      map['protein_name'] = proteinFileName!.split('.').first;
    }
    if (ligandFileName != null) {
      map['ligand_name'] = ligandFileName!.split('.').first;
    }

    return FormData.fromMap(map);
  }
}
