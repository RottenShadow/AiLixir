import 'package:ailixir/core/entities/ligand_details_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'ligand_details_state.dart';

class LigandDetailsCubit extends Cubit<LigandDetailsState> {
  LigandDetailsCubit() : super(LigandDetailsInitial());

  void loadDetails(LigandEntity ligand) {
    emit(LigandDetailsLoaded(details: ligand.toDetailsEntity()));
  }
}
