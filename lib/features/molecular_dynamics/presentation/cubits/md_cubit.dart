import 'dart:async';
import 'package:ailixir/core/entities/md_simulation_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'md_state.dart';

class MdCubit extends Cubit<MdState> {
  MdCubit() : super(MdState(config: const MdSimulationEntity()));

  // ── Config mutations ─────────────────────────────────────────────────────

  Future<void> pickProteinFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdb'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    _update(
      config: state.config.copyWith(
        proteinPdbPath: file.path ?? '',
        proteinPdbName: file.name,
      ),
    );
  }

  Future<void> pickLigandFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdb'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    _update(
      config: state.config.copyWith(
        ligandPdbPath: file.path ?? '',
        ligandPdbName: file.name,
      ),
    );
  }

  void clearProteinFile() =>
      _update(config: state.config.copyWith(proteinPdbPath: '', proteinPdbName: ''));

  void clearLigandFile() =>
      _update(config: state.config.copyWith(ligandPdbPath: '', ligandPdbName: ''));

  void setRemoveWaters(bool v) =>
      _update(config: state.config.copyWith(removeWaters: v));

  void setAddLigandHydrogens(bool v) =>
      _update(config: state.config.copyWith(addLigandHydrogens: v));

  void setSystemCharge(int v) =>
      _update(config: state.config.copyWith(systemTotalCharge: v));

  void setProteinForceField(String v) =>
      _update(config: state.config.copyWith(proteinForceField: v));

  void setLigandForceField(String v) =>
      _update(config: state.config.copyWith(ligandForceField: v));

  void setWaterModel(String v) =>
      _update(config: state.config.copyWith(waterModel: v));

  void setBoxSizePadding(double v) =>
      _update(config: state.config.copyWith(boxSizePadding: v));

  void setSaltType(String v) =>
      _update(config: state.config.copyWith(saltType: v));

  void setConcentration(double v) =>
      _update(config: state.config.copyWith(concentration: v));

  void setEquilibrationEnabled(bool v) =>
      _update(config: state.config.copyWith(equilibrationEnabled: v));

  void setEquilJobName(String v) =>
      _update(config: state.config.copyWith(equilJobName: v));

  void setMinimizationSteps(String v) =>
      _update(config: state.config.copyWith(minimizationSteps: v));

  void setEquilTimestep(double v) =>
      _update(config: state.config.copyWith(equilTimestep: v));

  void setEquilTemperature(double v) =>
      _update(config: state.config.copyWith(equilTemperature: v));

  void setEquilPressure(double v) =>
      _update(config: state.config.copyWith(equilPressure: v));

  void setRestraintForceConstant(double v) =>
      _update(config: state.config.copyWith(restraintForceConstant: v));

  void setEquilWriteTraj(double v) =>
      _update(config: state.config.copyWith(equilWriteTraj: v));

  void setEquilWriteLog(double v) =>
      _update(config: state.config.copyWith(equilWriteLog: v));

  void setProductionEnabled(bool v) =>
      _update(config: state.config.copyWith(productionEnabled: v));

  void setStrideDuration(double v) =>
      _update(config: state.config.copyWith(strideDuration: v));

  void setNumberOfStrides(int v) =>
      _update(config: state.config.copyWith(numberOfStrides: v));

  void setCompressTrajectory(bool v) =>
      _update(config: state.config.copyWith(compressTrajectory: v));

  void setCalculateRmsd(bool v) =>
      _update(config: state.config.copyWith(calculateRmsdOnTheFly: v));

  // ── Simulation lifecycle ─────────────────────────────────────────────────

  void startSimulation() {
    emit(
      state.copyWith(
        status: MdStatus.running,
        logs: ['[${_ts()}] Job submitted. Preparing MD environment...'],
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (isClosed) return;
      final success = DateTime.now().millisecondsSinceEpoch % 2 == 0;
      emit(
        state.copyWith(
          status: success ? MdStatus.completed : MdStatus.failure,
          logs: [
            ...state.logs,
            success
                ? '[${_ts()}] ✓ Simulation completed. Trajectory saved.'
                : '[${_ts()}] ✗ Simulation failed.',
          ],
        ),
      );
    });
  }

  void reset() {
    emit(MdState(config: const MdSimulationEntity()));
  }

  void _update({required MdSimulationEntity config}) {
    emit(state.copyWith(config: config));
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }
}
