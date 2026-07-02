part of 'md_history_cubit.dart';

@immutable
sealed class MdHistoryState {}

final class MdHistoryInitial extends MdHistoryState {}

final class MdHistoryLoading extends MdHistoryState {}

final class MdHistoryLoaded extends MdHistoryState {
  final List<MdEntity> mdSimulations;
  MdHistoryLoaded({required this.mdSimulations});
}

final class MdHistoryLoadingMore extends MdHistoryState {
  final List<MdEntity> mdSimulations;
  MdHistoryLoadingMore({required this.mdSimulations});
}

final class MdHistoryError extends MdHistoryState {
  final String message;
  MdHistoryError({required this.message});
}
