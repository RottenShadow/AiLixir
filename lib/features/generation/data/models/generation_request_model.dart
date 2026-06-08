import 'package:ailixir/core/entities/generation_request_entity.dart';

class GenerationRequestModel {
  final int numMolecules;
  final int returnTopK;
  final String dockingMode;
  final int dockTopK;

  const GenerationRequestModel({
    required this.numMolecules,
    required this.returnTopK,
    this.dockingMode = 'all',
    this.dockTopK = 5,
  });

  factory GenerationRequestModel.fromEntity(GenerationRequestEntity entity) {
    return GenerationRequestModel(
      numMolecules: entity.numGenerations,
      returnTopK: entity.numGenerations,
      dockTopK: entity.numGenerations,
    );
  }

  Map<String, dynamic> toJson() => {
        'num_molecules': numMolecules,
        'return_top_k': returnTopK,
        'docking_mode': dockingMode,
        'dock_top_k': dockTopK,
      };
}
