import 'package:ailixir/core/entities/generation_job_history_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'generation_history_state.dart';

class GenerationHistoryCubit extends Cubit<GenerationHistoryState> {
  static const _pageSize = 15;
  final repo = GetIt.I.get<HistoryRepo>();
  int _currentPage = 0;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => state is GenerationHistoryLoadingMore;

  GenerationHistoryCubit() : super(GenerationHistoryInitial());

  Future<void> load() async {
    emit(GenerationHistoryLoading());
    final result = await repo.getGenerationHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) => emit(GenerationHistoryError(message: failure.message)),
      (data) => emit(GenerationHistoryLoaded(jobs: data.results)),
    );
  }

  Future<void> loadAll() async {
    _currentPage = 0;
    _hasMore = true;
    emit(GenerationHistoryLoading());
    final result = await repo.getGenerationHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) => emit(GenerationHistoryError(message: failure.message)),
      (data) {
        _currentPage = 1;
        _hasMore = data.pagination.hasNextPage;
        emit(GenerationHistoryLoaded(jobs: data.results));
      },
    );
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is GenerationHistoryLoadingMore) return;
    final current = (state as GenerationHistoryLoaded).jobs;
    emit(GenerationHistoryLoadingMore(jobs: current));
    final result = await repo.getGenerationHistory(
      page: _currentPage + 1,
      perPage: _pageSize,
    );
    result.fold((failure) => emit(GenerationHistoryLoaded(jobs: current)), (
      data,
    ) {
      _currentPage++;
      _hasMore = data.pagination.hasNextPage;
      emit(GenerationHistoryLoaded(jobs: [...current, ...data.results]));
    });
  }
}
