import 'package:ailixir/core/entities/ligand_details_entity.dart';
import 'package:ailixir/features/history/data/repos/history_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'ligand_details_state.dart';

class LigandDetailsCubit extends Cubit<LigandDetailsState> {
  final repo = GetIt.I.get<HistoryRepo>();

  LigandDetailsCubit() : super(LigandDetailsInitial());

  Future<void> loadDetails(String ligandId) async {
    emit(LigandDetailsLoading());

    final result = await repo.getLigandDetails(ligandId);
    result.fold(
      (failure) {
        emit(LigandDetailsError(message: failure.message));
      },
      (details) {
        emit(LigandDetailsLoaded(details: details));
      },
    );
  }
}
