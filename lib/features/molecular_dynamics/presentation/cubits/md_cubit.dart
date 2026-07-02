import 'package:ailixir/core/entities/md_simulation_entity.dart';
import 'package:ailixir/features/molecular_dynamics/data/repos/md_simulation_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'md_state.dart';

class MdCubit extends Cubit<MdState> {
  final repo = GetIt.I.get<MdSimulationRepo>();

  MdCubit() : super(MdState(config: const MdSimulationEntity()));

  // ── File pickers ─────────────────────────────────────────────────────────

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

  void clearProteinFile() => _update(
    config: state.config.copyWith(proteinPdbPath: '', proteinPdbName: ''),
  );

  void clearLigandFile() => _update(
    config: state.config.copyWith(ligandPdbPath: '', ligandPdbName: ''),
  );

  // ── Config mutations ─────────────────────────────────────────────────────

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
      _update(config: state.config.copyWith(numberOfStrides: v.clamp(1, 10)));

  void setCompressTrajectory(bool v) =>
      _update(config: state.config.copyWith(compressTrajectory: v));

  void setCalculateRmsd(bool v) =>
      _update(config: state.config.copyWith(calculateRmsdOnTheFly: v));

  // ── Simulation lifecycle ─────────────────────────────────────────────────

  Future<void> startSimulation() async {
    final cfg = state.config;

    emit(
      state.copyWith(
        submitStatus: MdSubmitStatus.submitting,
        submittedJobId: null,
        errorMessage: null,
      ),
    );

    final result = await repo.submitJob(
      proteinPath: cfg.proteinPdbPath,
      proteinName: cfg.proteinPdbName,
      ligandPath: cfg.ligandPdbPath,
      ligandName: cfg.ligandPdbName,
      forceField: cfg.proteinForceField,
      netCharge: cfg.systemTotalCharge,
      boxSize: cfg.boxSizePadding,
      ionType: cfg.saltType,
      saltConc: cfg.concentration,
      removeWaters: cfg.removeWaters,
      addHydrogens: cfg.addLigandHydrogens,
      equilTimeNs: cfg.equilTimestep,
      simTimeNs: cfg.strideDuration / 1000,
      nStrides: cfg.numberOfStrides,
      temperatureK: cfg.equilTemperature,
      pressureBar: cfg.equilPressure,
      dtFs: cfg.equilTimestep.round(),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            submitStatus: MdSubmitStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (job) {
        emit(
          state.copyWith(
            submitStatus: MdSubmitStatus.submitted,
            submittedJobId: job.remoteJobId,
          ),
        );
      },
    );
  }

  void reset() {
    emit(MdState(config: const MdSimulationEntity()));
  }

  void _update({required MdSimulationEntity config}) {
    emit(state.copyWith(config: config));
  }
}
