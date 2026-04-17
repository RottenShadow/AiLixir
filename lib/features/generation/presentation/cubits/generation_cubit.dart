import 'dart:async';
import 'package:ailixir/core/entities/generation_request_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'generation_state.dart';

class GenerationCubit extends Cubit<GenerationState> {
  GenerationCubit() : super(const GenerationState());

  Timer? _pollTimer;
  int _pollCount = 0;

  static const _pollInterval = Duration(seconds: 15);
  // For demo: complete after 2 poll cycles
  static const _completionCycle = 2;

  void startGeneration(GenerationRequestEntity request) {
    _cancelTimer();
    _pollCount = 0;

    emit(
      state.copyWith(
        status: GenerationStatus.polling,
        request: request,
        logs: ['[${_timestamp()}] Job submitted. Waiting to start...'],
        results: [],
      ),
    );

    // First poll immediately, then every 15s
    _poll();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
  }

  void _poll() {
    if (isClosed) return;
    _pollCount++;

    final newLog = _pollCount == 1
        ? '[${_timestamp()}] Generation in progress... (poll $_pollCount)'
        : '[${_timestamp()}] Still running... checking status (poll $_pollCount)';

    emit(state.copyWith(logs: [...state.logs, newLog]));

    if (_pollCount >= _completionCycle) {
      _cancelTimer();
      final ligands = LigandEntity.createFakeData();
      emit(
        state.copyWith(
          status: GenerationStatus.completed,
          logs: [
            ...state.logs,
            '[${_timestamp()}] ✓ Job Completed. ${ligands.length} candidates generated.',
          ],
          results: ligands,
        ),
      );
    }
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    emit(const GenerationState());
  }

  void _cancelTimer() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
