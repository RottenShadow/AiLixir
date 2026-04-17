part of 'docking_cubit.dart';

enum DockingStatus { idle, polling, completed }

@immutable
class DockingState {
  final DockingStatus status;
  final DockingRequestEntity? request;
  final List<String> logs;
  final List<DockingEntity> results;

  const DockingState({
    this.status = DockingStatus.idle,
    this.request,
    this.logs = const [],
    this.results = const [],
  });

  DockingState copyWith({
    DockingStatus? status,
    DockingRequestEntity? request,
    List<String>? logs,
    List<DockingEntity>? results,
  }) {
    return DockingState(
      status: status ?? this.status,
      request: request ?? this.request,
      logs: logs ?? this.logs,
      results: results ?? this.results,
    );
  }
}
