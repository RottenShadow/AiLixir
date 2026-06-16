import 'package:ailixir/core/entities/generation_request_entity.dart';

class GenerationRequestModel {
  final int numMolecules;
  final int returnTopK;
  final String dockingMode;
  final int dockTopK;

  const GenerationRequestModel({
    required this.numMolecules,
    required this.returnTopK,
    this.dockingMode = 'off',
    this.dockTopK = 1,
  });

  factory GenerationRequestModel.fromEntity(GenerationRequestEntity entity) {
    return GenerationRequestModel(
      numMolecules: entity.numMolecules,
      returnTopK: entity.returnTopK,
      dockingMode: entity.dockingMode,
      dockTopK: entity.dockTopK ?? entity.returnTopK,
    );
  }

  Map<String, dynamic> toJson() => {
    'num_molecules': numMolecules,
    'return_top_k': returnTopK,
    'docking_mode': dockingMode,
    'dock_top_k': dockTopK,
  };
}
