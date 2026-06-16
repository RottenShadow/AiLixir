import 'package:get_it/get_it.dart';
import 'package:ailixir/features/admet/data/repos/admet_repo.dart';
import 'package:ailixir/features/admet/domain/entities/admet_predict_response_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admet_state.dart';

class AdmetCubit extends Cubit<AdmetState> {
  final _repo = GetIt.I.get<AdmetRepo>();

  final List<String> _logs = [];

  AdmetCubit() : super(const AdmetIdle());

  Future<void> predictAdmet(List<String> smiles) async {
    void addLog(String msg) {
      _logs.add('[${_ts()}] $msg');
      emit(AdmetLoading(logs: List.unmodifiable(_logs)));
    }

    addLog('Starting ADMET prediction pipeline...');
    addLog('Validating ${smiles.length} SMILES strings...');

    final result = await _repo.predictAdmet(smiles);

    result.fold(
      (failure) {
        _logs.add('[${_ts()}] ✗ Error: ${failure.message}');
        emit(
          AdmetError(message: failure.message, logs: List.unmodifiable(_logs)),
        );
      },
      (response) {
        _logs.add(
          '[${_ts()}] ✓ Generated predictions for ${response.results.length} compounds.',
        );
        _logs.add('[${_ts()}] ✓ ADMET prediction complete.');
        emit(AdmetSuccess(response: response, logs: List.unmodifiable(_logs)));
      },
    );
  }

  Future<void> predictAdmetFromFile(String filePath) async {
    void addLog(String msg) {
      _logs.add('[${_ts()}] $msg');
      emit(AdmetLoading(logs: List.unmodifiable(_logs)));
    }

    addLog('Starting ADMET prediction pipeline from file...');
    addLog('Processing file: $filePath');

    final result = await _repo.predictAdmetFromFile(filePath);

    result.fold(
      (failure) {
        _logs.add('[${_ts()}] ✗ Error: ${failure.message}');
        emit(
          AdmetError(message: failure.message, logs: List.unmodifiable(_logs)),
        );
      },
      (response) {
        _logs.add(
          '[${_ts()}] ✓ Generated predictions for ${response.results.length} compounds.',
        );
        _logs.add('[${_ts()}] ✓ ADMET prediction complete.');
        emit(AdmetSuccess(response: response, logs: List.unmodifiable(_logs)));
      },
    );
  }

  void clearLogs() {
    _logs.clear();
    _logs.add('');
    if (state is AdmetSuccess) {
      emit(
        AdmetSuccess(response: (state as AdmetSuccess).response, logs: _logs),
      );
    } else if (state is AdmetError) {
      emit(AdmetError(message: (state as AdmetError).message, logs: _logs));
    } else if (state is AdmetLoading) {
      emit(AdmetLoading(logs: _logs));
    } else {
      emit(AdmetIdle(logs: _logs));
    }
  }

  void reset() {
    _logs.clear();
    emit(const AdmetIdle());
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }
}
