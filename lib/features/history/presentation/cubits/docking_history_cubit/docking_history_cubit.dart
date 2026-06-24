import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'docking_history_state.dart';

class DockingHistoryCubit extends Cubit<DockingHistoryState> {
  static const _pageSize = 15;
  final repo = GetIt.I.get<HistoryRepo>();
  int _currentPage = 0;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => state is DockingHistoryLoadingMore;

  DockingHistoryCubit() : super(DockingHistoryInitial());

  Future<void> load() async {
    emit(DockingHistoryLoading());
    final result = await repo.getDockingHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) => emit(DockingHistoryError(message: failure.message)),
      (data) => emit(DockingHistoryLoaded(dockings: data.results)),
    );
  }

  Future<void> loadAll() async {
    _currentPage = 0;
    _hasMore = true;
    emit(DockingHistoryLoading());
    final result = await repo.getDockingHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) => emit(DockingHistoryError(message: failure.message)),
      (data) {
        _currentPage = 1;
        _hasMore = data.pagination.hasNextPage;
        emit(DockingHistoryLoaded(dockings: data.results));
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is DockingHistoryLoadingMore) return;
    final current = (state as DockingHistoryLoaded).dockings;
    emit(DockingHistoryLoadingMore(dockings: current));
    final result = await repo.getDockingHistory(
      page: _currentPage + 1,
      perPage: _pageSize,
    );
    result.fold((failure) => emit(DockingHistoryLoaded(dockings: current)), (
      data,
    ) {
      _currentPage++;
      _hasMore = data.pagination.hasNextPage;
      emit(DockingHistoryLoaded(dockings: [...current, ...data.results]));
    });
  }
}
