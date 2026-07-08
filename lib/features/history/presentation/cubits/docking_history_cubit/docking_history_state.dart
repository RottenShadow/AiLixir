part of 'docking_history_cubit.dart';

@immutable
sealed class DockingHistoryState {}

final class DockingHistoryInitial extends DockingHistoryState {}

final class DockingHistoryLoading extends DockingHistoryState {}

final class DockingHistoryLoaded extends DockingHistoryState {
  final List<DockingEntity> dockings;
  DockingHistoryLoaded({required this.dockings});
}

final class DockingHistoryLoadingMore extends DockingHistoryState {
  final List<DockingEntity> dockings;
  DockingHistoryLoadingMore({required this.dockings});
}

final class DockingHistoryError extends DockingHistoryState {
  final String message;
  DockingHistoryError({required this.message});
}
