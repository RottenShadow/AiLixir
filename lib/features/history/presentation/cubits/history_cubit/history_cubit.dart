import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final repo = GetIt.I.get<HistoryRepo>();

  HistoryCubit() : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());

    final genResult = await repo.getGenerationHistory(page: 1, perPage: 10);
    final dockResult = await repo.getDockingHistory(page: 1, perPage: 10);

    genResult.fold(
      (failure) {
        emit(HistoryError(message: failure.message));
      },
      (genData) {
        dockResult.fold(
          (failure) {
            emit(HistoryError(message: failure.message));
          },
          (dockData) {
            emit(
              HistoryLoaded(
                ligands: genData.results,
                dockings: dockData.results,
                mdSimulations: [],
              ),
            );
          },
        );
      },
    );
  }
}
