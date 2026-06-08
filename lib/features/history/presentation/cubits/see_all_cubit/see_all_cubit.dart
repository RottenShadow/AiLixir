import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'see_all_state.dart';

class LigandSeeAllCubit extends Cubit<SeeAllState<LigandEntity>> {
  static const _pageSize = 10;
  final repo = GetIt.I.get<HistoryRepo>();

  LigandSeeAllCubit() : super(const SeeAllState());

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: SeeAllStatus.loading,
        items: [],
        page: 0,
        hasMore: true,
      ),
    );

    final result = await repo.getGenerationHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) {
        emit(state.copyWith(status: SeeAllStatus.loaded, hasMore: false));
      },
      (data) {
        emit(
          state.copyWith(
            status: SeeAllStatus.loaded,
            items: data.results,
            page: data.pagination.currentPage + 1,
            hasMore: data.pagination.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SeeAllStatus.loadingMore || !state.hasMore) return;

    emit(state.copyWith(status: SeeAllStatus.loadingMore));

    final result = await repo.getGenerationHistory(
      page: state.page,
      perPage: _pageSize,
    );
    result.fold(
      (failure) {
        emit(state.copyWith(status: SeeAllStatus.loaded));
      },
      (data) {
        emit(
          state.copyWith(
            status: SeeAllStatus.loaded,
            items: [...state.items, ...data.results],
            page: data.pagination.currentPage + 1,
            hasMore: data.pagination.hasNextPage,
          ),
        );
      },
    );
  }
}

class DockingSeeAllCubit extends Cubit<SeeAllState<DockingEntity>> {
  static const _pageSize = 10;
  final repo = GetIt.I.get<HistoryRepo>();

  DockingSeeAllCubit() : super(const SeeAllState());

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: SeeAllStatus.loading,
        items: [],
        page: 0,
        hasMore: true,
      ),
    );

    final result = await repo.getDockingHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) {
        emit(state.copyWith(status: SeeAllStatus.loaded, hasMore: false));
      },
      (data) {
        emit(
          state.copyWith(
            status: SeeAllStatus.loaded,
            items: data.results,
            page: data.pagination.currentPage + 1,
            hasMore: data.pagination.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SeeAllStatus.loadingMore || !state.hasMore) return;

    emit(state.copyWith(status: SeeAllStatus.loadingMore));

    final result = await repo.getDockingHistory(
      page: state.page,
      perPage: _pageSize,
    );
    result.fold(
      (failure) {
        emit(state.copyWith(status: SeeAllStatus.loaded));
      },
      (data) {
        emit(
          state.copyWith(
            status: SeeAllStatus.loaded,
            items: [...state.items, ...data.results],
            page: data.pagination.currentPage + 1,
            hasMore: data.pagination.hasNextPage,
          ),
        );
      },
    );
  }
}

class MdSeeAllCubit extends Cubit<SeeAllState<MdEntity>> {
  static const _pageSize = 10;
  final repo = GetIt.I.get<HistoryRepo>();

  MdSeeAllCubit() : super(const SeeAllState());

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: SeeAllStatus.loading,
        items: [],
        page: 0,
        hasMore: true,
      ),
    );

    final result = await repo.getMdHistory(page: 1, perPage: _pageSize);
    result.fold(
      (failure) {
        emit(state.copyWith(status: SeeAllStatus.loaded, hasMore: false));
      },
      (data) {
        emit(
          state.copyWith(
            status: SeeAllStatus.loaded,
            items: data.results,
            page: data.pagination.currentPage + 1,
            hasMore: data.pagination.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SeeAllStatus.loadingMore || !state.hasMore) return;

    emit(state.copyWith(status: SeeAllStatus.loadingMore));

    final result = await repo.getMdHistory(
      page: state.page,
      perPage: _pageSize,
    );
    result.fold(
      (failure) {
        emit(state.copyWith(status: SeeAllStatus.loaded));
      },
      (data) {
        emit(
          state.copyWith(
            status: SeeAllStatus.loaded,
            items: [...state.items, ...data.results],
            page: data.pagination.currentPage + 1,
            hasMore: data.pagination.hasNextPage,
          ),
        );
      },
    );
  }
}
