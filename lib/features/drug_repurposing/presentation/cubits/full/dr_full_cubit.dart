import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_screen_request_entity.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_screen_response_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dr_full_state.dart';

class DrFullCubit extends Cubit<DrFullState> {
  final DrugRepurposingRepository _repository;
  final List<String> _logs = [];

  DrFullCubit({required DrugRepurposingRepository repository})
    : _repository = repository,
      super(const DrFullIdle());

  Future<void> screenDrugs({
    required String diseaseName,
    required List<String> knownDrugs,
    required List<String> extraSmiles,
    required int topK,
  }) async {
    void addLog(String msg) {
      _logs.add('[${_ts()}] $msg');
      emit(DrFullLoading(logs: List.unmodifiable(_logs)));
    }

    addLog('Starting full drug repurposing pipeline...');
    await Future.delayed(const Duration(milliseconds: 300));

    addLog('Fetching disease targets for "$diseaseName"...');
    await Future.delayed(const Duration(milliseconds: 500));

    addLog('Loading protein structures from PDB...');
    await Future.delayed(const Duration(milliseconds: 500));

    addLog(
      'Preparing ${knownDrugs.length} known drugs + ${extraSmiles.length} extra SMILES...',
    );
    await Future.delayed(const Duration(milliseconds: 400));

    addLog('Running AI-powered binding affinity screening...');
    await Future.delayed(const Duration(milliseconds: 600));

    addLog('Ranking top-$topK drug-target pairs by binding score...');

    try {
      final request = DrugRepurposingScreenRequestEntity(
        diseaseName: diseaseName,
        knownDrugs: knownDrugs,
        extraSmiles: extraSmiles,
        topK: topK,
      );

      final response = await _repository.screenDrugs(request);

      _logs.add(
        '[${_ts()}] ✓ Screened ${response.totalPairsEvaluated} drug-target pairs.',
      );
      _logs.add(
        '[${_ts()}] ✓ Identified ${response.topCandidates.length} top candidates.',
      );
      _logs.add('[${_ts()}] ✓ Full screening complete.');

      emit(DrFullSuccess(response: response, logs: List.unmodifiable(_logs)));
    } catch (e) {
      _logs.add(
        '[${_ts()}] ✗ Error: ${e.toString().replaceAll('Exception: ', '')}',
      );
      emit(
        DrFullError(
          message: e.toString().replaceAll('Exception: ', ''),
          logs: List.unmodifiable(_logs),
        ),
      );
    }
  }

  void clearLogs() {
    _logs.clear();
    _logs.add('');
    if (state is DrFullSuccess) {
      emit(
        DrFullSuccess(response: (state as DrFullSuccess).response, logs: _logs),
      );
    } else if (state is DrFullError) {
      emit(DrFullError(message: (state as DrFullError).message, logs: _logs));
    } else if (state is DrFullLoading) {
      emit(DrFullLoading(logs: _logs));
    } else {
      emit(DrFullIdle(logs: _logs));
    }
  }

  void reset() {
    _logs.clear();
    emit(const DrFullIdle());
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }
}
