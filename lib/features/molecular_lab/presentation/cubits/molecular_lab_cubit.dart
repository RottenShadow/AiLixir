import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

part 'molecular_lab_state.dart';

class MolecularLabCubit extends Cubit<MolecularLabState> {
  MolecularLabCubit() : super(MolecularLabInitial()) {
    _init();
  }
  final InAppLocalhostServer _localhostServer = InAppLocalhostServer(
    documentRoot: 'assets/web/viewer',
  );
  void _init() async {
    await _localhostServer.start();
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
    await _localhostServer.close();
    await super.close();
  }
}
