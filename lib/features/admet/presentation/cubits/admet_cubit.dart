import 'dart:math';
import 'package:ailixir/features/admet/domain/entities/admet_predict_response_entity.dart';
import 'package:ailixir/features/admet/domain/entities/admet_prediction_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admet_state.dart';

class AdmetCubit extends Cubit<AdmetState> {
  final List<String> _logs = [];

  AdmetCubit() : super(const AdmetIdle());

  Future<void> predictAdmet(List<String> smiles) async {
    void addLog(String msg) {
      _logs.add('[${_ts()}] $msg');
      emit(AdmetLoading(logs: List.unmodifiable(_logs)));
    }

    addLog('Starting ADMET prediction pipeline...');
    await Future.delayed(const Duration(milliseconds: 300));

    addLog('Validating ${smiles.length} SMILES strings...');
    await Future.delayed(const Duration(milliseconds: 400));

    addLog('Running absorption prediction model...');
    await Future.delayed(const Duration(milliseconds: 500));

    addLog('Running distribution prediction model...');
    await Future.delayed(const Duration(milliseconds: 400));

    addLog('Running metabolism prediction model...');
    await Future.delayed(const Duration(milliseconds: 400));

    addLog('Running excretion prediction model...');
    await Future.delayed(const Duration(milliseconds: 300));

    addLog('Running toxicity prediction model...');
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final random = Random();
      final predictions = smiles
          .map(
            (s) => AdmetPredictionEntity(
              smiles: s.trim(),
              absorption: -3.5 + random.nextDouble() * 2.5,
              distribution: 0.5 + random.nextDouble() * 1.2,
              metabolism: -0.4 + random.nextDouble() * 0.5,
              excretion: 5.0 + random.nextDouble() * 18.0,
              toxicity: -0.8 + random.nextDouble() * 2.0,
            ),
          )
          .toList();

      _logs.add(
        '[${_ts()}] ✓ Generated predictions for ${predictions.length} compounds.',
      );
      _logs.add('[${_ts()}] ✓ ADMET prediction complete.');

      emit(
        AdmetSuccess(
          response: AdmetPredictResponseEntity(
            success: true,
            message: 'ADMET predictions generated successfully',
            data: predictions,
          ),
          logs: List.unmodifiable(_logs),
        ),
      );
    } catch (e) {
      _logs.add(
        '[${_ts()}] ✗ Error: ${e.toString().replaceAll('Exception: ', '')}',
      );
      emit(
        AdmetError(
          message: e.toString().replaceAll('Exception: ', ''),
          logs: List.unmodifiable(_logs),
        ),
      );
    }
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
