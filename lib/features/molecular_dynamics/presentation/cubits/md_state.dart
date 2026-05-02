part of 'md_cubit.dart';

enum MdStatus { idle, running, completed }

@immutable
class MdState {
  final MdStatus status;
  final MdSimulationEntity config;
  final List<String> logs;

  const MdState({
    this.status = MdStatus.idle,
    required this.config,
    this.logs = const [],
  });

  MdState copyWith({
    MdStatus? status,
    MdSimulationEntity? config,
    List<String>? logs,
  }) {
    return MdState(
      status: status ?? this.status,
      config: config ?? this.config,
      logs: logs ?? this.logs,
    );
  }
}
