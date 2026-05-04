import 'package:ailixir/core/entities/ligand_details_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'ligand_details_state.dart';

class LigandDetailsCubit extends Cubit<LigandDetailsState> {
  LigandDetailsCubit() : super(LigandDetailsInitial());

  Future<void> loadDetails(String ligandId) async {
    emit(LigandDetailsLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(
      LigandDetailsLoaded(
        details: LigandDetailsEntity.createFakeData(ligandId),
      ),
    );
  }
}
