import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_targets_response_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dr_quick_state.dart';

class DrQuickCubit extends Cubit<DrQuickState> {
  final DrugRepurposingRepository _repository;
  final List<String> _logs = [];

  DrQuickCubit({required DrugRepurposingRepository repository})
    : _repository = repository,
      super(const DrQuickIdle());

  Future<void> getTargets(String diseaseName) async {
    void addLog(String msg) {
      _logs.add('[${_ts()}] $msg');
      emit(DrQuickLoading(logs: List.unmodifiable(_logs)));
    }

    addLog('Initializing target discovery for "$diseaseName"...');
    await Future.delayed(const Duration(milliseconds: 400));

    addLog('Querying disease-gene association database...');
    await Future.delayed(const Duration(milliseconds: 600));

    addLog('Fetching protein targets from OpenTargets...');

    try {
      final response = await _repository.getTargets(diseaseName);

      _logs.add(
        '[${_ts()}] ✓ Found ${response.totalTargets} molecular targets.',
      );
      _logs.add('[${_ts()}] ✓ Target discovery complete.');

      emit(DrQuickSuccess(response: response, logs: List.unmodifiable(_logs)));
    } catch (e) {
      _logs.add(
        '[${_ts()}] ✗ Error: ${e.toString().replaceAll('Exception: ', '')}',
      );
      emit(
        DrQuickError(
          message: e.toString().replaceAll('Exception: ', ''),
          logs: List.unmodifiable(_logs),
        ),
      );
    }
  }

  void clearLogs() {
    _logs.clear();
    _logs.add('');
    if (state is DrQuickSuccess) {
      emit(
        DrQuickSuccess(
          response: (state as DrQuickSuccess).response,
          logs: _logs,
        ),
      );
    } else if (state is DrQuickError) {
      emit(DrQuickError(message: (state as DrQuickError).message, logs: _logs));
    } else if (state is DrQuickLoading) {
      emit(DrQuickLoading(logs: _logs));
    } else {
      emit(DrQuickIdle(logs: _logs));
    }
  }

  void reset() {
    _logs.clear();
    emit(const DrQuickIdle());
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }
}
