import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    await Future.delayed(const Duration(milliseconds: 1200));
    emit(
      HistoryLoaded(
        ligands: LigandEntity.createFakeData(),
        dockings: DockingEntity.createFakeData(),
        mdSimulations: MdEntity.createFakeData(),
      ),
    );
  }
}
