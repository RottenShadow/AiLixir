import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'md_history_state.dart';

class MdHistoryCubit extends Cubit<MdHistoryState> {
  static const _pageSize = 10;
  final repo = GetIt.I.get<HistoryRepo>();
  int _currentPage = 0;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => state is MdHistoryLoadingMore;

  MdHistoryCubit() : super(MdHistoryInitial());

  Future<void> load() async {
    emit(MdHistoryLoading());
    final result = await repo.getMdHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) => emit(MdHistoryError(message: failure.message)),
      (data) => emit(MdHistoryLoaded(mdSimulations: data.results)),
    );
  }

  Future<void> loadAll() async {
    _currentPage = 0;
    _hasMore = true;
    emit(MdHistoryLoading());
    final result = await repo.getMdHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) => emit(MdHistoryError(message: failure.message)),
      (data) {
        _currentPage = 1;
        _hasMore = data.pagination.hasNextPage;
        emit(MdHistoryLoaded(mdSimulations: data.results));
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is MdHistoryLoadingMore) return;
    final current = (state as MdHistoryLoaded).mdSimulations;
    emit(MdHistoryLoadingMore(mdSimulations: current));
    final result = await repo.getMdHistory(
      page: _currentPage + 1,
      perPage: _pageSize,
    );
    result.fold(
      (failure) => emit(MdHistoryLoaded(mdSimulations: current)),
      (data) {
        _currentPage++;
        _hasMore = data.pagination.hasNextPage;
        emit(MdHistoryLoaded(mdSimulations: [...current, ...data.results]));
      },
    );
  }
}
