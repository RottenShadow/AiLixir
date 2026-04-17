import 'dart:async';
import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/docking_request_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'docking_state.dart';

class DockingCubit extends Cubit<DockingState> {
  DockingCubit() : super(const DockingState());

  Timer? _pollTimer;
  int _pollCount = 0;

  static const _pollInterval = Duration(seconds: 15);
  static const _completionCycle = 2;

  void startDocking(DockingRequestEntity request) {
    _cancelTimer();
    _pollCount = 0;

    emit(
      state.copyWith(
        status: DockingStatus.polling,
        request: request,
        logs: ['[${_ts()}] Job submitted. Preparing docking environment...'],
        results: [],
      ),
    );

    _poll();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
  }

  void _poll() {
    if (isClosed) return;
    _pollCount++;

    final log = _pollCount == 1
        ? '[${_ts()}] Docking in progress... running AutoDock Vina (poll $_pollCount)'
        : '[${_ts()}] Still running... evaluating binding poses (poll $_pollCount)';

    emit(state.copyWith(logs: [...state.logs, log]));

    if (_pollCount >= _completionCycle) {
      _cancelTimer();
      final results = DockingEntity.createFakeData().take(1).toList();
      emit(
        state.copyWith(
          status: DockingStatus.completed,
          logs: [
            ...state.logs,
            '[${_ts()}] ✓ Job Completed. ${results.length} docking poses found.',
          ],
          results: results,
        ),
      );
    }
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    emit(const DockingState());
  }

  void _cancelTimer() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
