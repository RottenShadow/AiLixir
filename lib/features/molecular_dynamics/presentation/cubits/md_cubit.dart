import 'dart:async';
import 'package:ailixir/core/entities/md_simulation_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'md_state.dart';

class MdCubit extends Cubit<MdState> {
  MdCubit() : super(MdState(config: const MdSimulationEntity()));

  Timer? _pollTimer;
  int _pollCount = 0;

  static const _pollInterval = Duration(seconds: 10);
  static const _completionCycle = 3;

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
    _cancelTimer();
    _pollCount = 0;

    emit(
      state.copyWith(
        status: MdStatus.running,
        logs: ['[${_ts()}] Job submitted. Preparing MD environment...'],
      ),
    );

    _poll();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
  }

  void _poll() {
    if (isClosed) return;
    _pollCount++;

    final log = switch (_pollCount) {
      1 => '[${_ts()}] Building simulation box with LEaP...',
      2 => '[${_ts()}] Running energy minimization (${state.config.minimizationSteps} steps)...',
      _ =>
        '[${_ts()}] MD running... ${state.config.equilTemperature.toInt()} K / ${state.config.equilPressure.toStringAsFixed(2)} bar (poll $_pollCount)',
    };

    emit(state.copyWith(logs: [...state.logs, log]));

    if (_pollCount >= _completionCycle) {
      _cancelTimer();
      emit(
        state.copyWith(
          status: MdStatus.completed,
          logs: [
            ...state.logs,
            '[${_ts()}] ✓ Simulation completed. Trajectory saved.',
          ],
        ),
      );
    }
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    emit(MdState(config: const MdSimulationEntity()));
  }

  void _update({required MdSimulationEntity config}) {
    emit(state.copyWith(config: config));
  }

  void _cancelTimer() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
