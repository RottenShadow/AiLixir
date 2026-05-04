import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ailixir/core/services/molstar_server_service.dart';

part 'molecular_lab_state.dart';

class MolecularLabCubit extends Cubit<MolecularLabState> {
  MolecularLabCubit() : super(MolecularLabInitial()) {
    _init();
  }

  void _init() async {
    await MolstarServerService().start();
  }

  void loadPdb(String id) {
    if (id.trim().isEmpty) return;
    emit(
      MolecularLabLoaded(
        pdbId: id.trim().toUpperCase(),
        timestamp: DateTime.now(),
      ),
    );
  }

  void reset() {
    emit(MolecularLabInitial());
  }

  @override
  Future<void> close() async {
    // We don't stop the server here because it might be needed by other views
    await super.close();
  }
}
