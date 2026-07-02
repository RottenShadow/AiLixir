import 'package:ailixir/core/entities/drug_repurposing_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'drug_repurposing_state.dart';

class DrugRepurposingCubit extends Cubit<DrugRepurposingState> {
  static const _pageSize = 15;
  final repo = GetIt.I.get<HistoryRepo>();
  int _targetsPage = 0;
  int _screenPage = 0;
  bool _targetsHasMore = true;
  bool _screenHasMore = true;

  bool get hasMore {
    if (state is DrugRepurposingLoaded) {
      final tab = (state as DrugRepurposingLoaded).selectedSubTab;
      return tab == DrugRepurposingSubTab.targets ? _targetsHasMore : _screenHasMore;
    }
    if (state is DrugRepurposingLoadingMore) {
      final tab = (state as DrugRepurposingLoadingMore).selectedSubTab;
      return tab == DrugRepurposingSubTab.targets ? _targetsHasMore : _screenHasMore;
    }
    return true;
  }

  bool get isLoadingMore => state is DrugRepurposingLoadingMore;

  DrugRepurposingCubit() : super(DrugRepurposingInitial());

  Future<void> load() async {
    emit(DrugRepurposingLoading());
    final targetsResult =
        await repo.getDrugRepurposingTargetsHistory(page: 1, perPage: _pageSize);
    final screenResult =
        await repo.getDrugRepurposingScreenHistory(page: 1, perPage: _pageSize);

    targetsResult.fold(
      (failure) => emit(DrugRepurposingError(message: failure.message)),
      (targetsData) {
        screenResult.fold(
          (failure) => emit(DrugRepurposingError(message: failure.message)),
          (screenData) {
            emit(
              DrugRepurposingLoaded(
                targets: targetsData.results,
                screen: screenData.results,
                selectedSubTab: DrugRepurposingSubTab.targets,
              ),
            );
          },
        );
      },
    );
  }

  void selectSubTab(DrugRepurposingSubTab subTab) {
    final current = state;
    if (current is DrugRepurposingLoaded) {
      emit(
        DrugRepurposingLoaded(
          targets: current.targets,
          screen: current.screen,
          selectedSubTab: subTab,
        ),
      );
    }
  }

  Future<void> loadAll(DrugRepurposingType initialTab) async {
    _targetsPage = 0;
    _screenPage = 0;
    _targetsHasMore = true;
    _screenHasMore = true;
    emit(DrugRepurposingLoading());

    final targetsResult =
        await repo.getDrugRepurposingTargetsHistory(page: 1, perPage: _pageSize);
    final screenResult =
        await repo.getDrugRepurposingScreenHistory(page: 1, perPage: _pageSize);

    targetsResult.fold(
      (failure) => emit(DrugRepurposingError(message: failure.message)),
      (targetsData) {
        screenResult.fold(
          (failure) => emit(DrugRepurposingError(message: failure.message)),
          (screenData) {
            _targetsPage = 1;
            _screenPage = 1;
            _targetsHasMore = targetsData.pagination.hasNextPage;
            _screenHasMore = screenData.pagination.hasNextPage;
            emit(
              DrugRepurposingLoaded(
                targets: targetsData.results,
                screen: screenData.results,
                selectedSubTab: initialTab == DrugRepurposingType.targets
                    ? DrugRepurposingSubTab.targets
                    : DrugRepurposingSubTab.screen,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> loadMore() async {
    final st = state;
    if (st is! DrugRepurposingLoaded || isLoadingMore) return;
    final isTargets = st.selectedSubTab == DrugRepurposingSubTab.targets;
    if (isTargets ? !_targetsHasMore : !_screenHasMore) return;

    emit(DrugRepurposingLoadingMore(
      targets: st.targets,
      screen: st.screen,
      selectedSubTab: st.selectedSubTab,
    ));

    final fetch = isTargets
        ? repo.getDrugRepurposingTargetsHistory(
            page: _targetsPage + 1, perPage: _pageSize)
        : repo.getDrugRepurposingScreenHistory(
            page: _screenPage + 1, perPage: _pageSize);

    final result = await fetch;
    result.fold(
      (failure) => emit(
        DrugRepurposingLoaded(
          targets: st.targets,
          screen: st.screen,
          selectedSubTab: st.selectedSubTab,
        ),
      ),
      (data) {
        if (isTargets) {
          _targetsPage++;
          _targetsHasMore = data.pagination.hasNextPage;
          emit(DrugRepurposingLoaded(
            targets: [...st.targets, ...data.results],
            screen: st.screen,
            selectedSubTab: DrugRepurposingSubTab.targets,
          ));
        } else {
          _screenPage++;
          _screenHasMore = data.pagination.hasNextPage;
          emit(DrugRepurposingLoaded(
            targets: st.targets,
            screen: [...st.screen, ...data.results],
            selectedSubTab: DrugRepurposingSubTab.screen,
          ));
        }
      },
    );
  }
}
