part of 'history_cubit.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryLoaded extends HistoryState {
  final List<LigandEntity> ligands;
  final List<DockingEntity> dockings;
  final List<MdEntity> mdSimulations;

  HistoryLoaded({
    required this.ligands,
    required this.dockings,
    required this.mdSimulations,
  });
}

final class HistoryError extends HistoryState {
  final String message;
  HistoryError({required this.message});
}
