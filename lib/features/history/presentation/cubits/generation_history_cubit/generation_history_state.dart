part of 'generation_history_cubit.dart';

@immutable
sealed class GenerationHistoryState {}

final class GenerationHistoryInitial extends GenerationHistoryState {}

final class GenerationHistoryLoading extends GenerationHistoryState {}

final class GenerationHistoryLoaded extends GenerationHistoryState {
  final List<LigandEntity> ligands;
  GenerationHistoryLoaded({required this.ligands});
}

final class GenerationHistoryLoadingMore extends GenerationHistoryState {
  final List<LigandEntity> ligands;
  GenerationHistoryLoadingMore({required this.ligands});
}

final class GenerationHistoryError extends GenerationHistoryState {
  final String message;
  GenerationHistoryError({required this.message});
}
