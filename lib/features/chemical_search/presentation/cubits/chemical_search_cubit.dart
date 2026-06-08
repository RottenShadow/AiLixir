import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/features/chemical_search/data/repos/chemical_search_repo.dart';
import 'package:ailixir/features/chemical_search/domain/entities/chemical_search_entity.dart';

part 'chemical_search_state.dart';

class ChemicalSearchCubit extends Cubit<ChemicalSearchState> {
  final _repo = GetIt.I.get<ChemicalSearchRepo>();

  final List<String> _logs = [];
  final bool fullRag;

  ChemicalSearchCubit({this.fullRag = false})
    : super(const ChemicalSearchIdle());

  Future<void> search({required String smiles, int topK = 3}) async {
    _logs.clear();
    _logs.add('[${_ts()}] Initializing chemical similarity search...');
    emit(ChemicalSearchLoading(smiles: smiles, logs: List.unmodifiable(_logs)));

    final result = await _repo.search(
      smiles: smiles,
      topK: topK,
      fullRag: fullRag,
    );

    result.fold(
      (failure) {
        _logs.add('[${_ts()}] ✗ Error: ${failure.message}');
        emit(
          ChemicalSearchError(
            message: failure.message,
            smiles: smiles,
            logs: List.unmodifiable(_logs),
          ),
        );
      },
      (response) {
        _logs.add(
          '[${_ts()}] Found ${response.results.length} similar compounds.',
        );
        emit(
          ChemicalSearchSuccess(
            response: response,
            smiles: smiles,
            logs: List.unmodifiable(_logs),
          ),
        );
      },
    );
  }

  void reset() {
    _logs.clear();
    emit(const ChemicalSearchIdle());
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }
}
