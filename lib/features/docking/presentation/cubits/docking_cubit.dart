import 'dart:async';
import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/docking_request_entity.dart';
import 'package:ailixir/features/docking/data/repos/docking_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'docking_state.dart';

class DockingCubit extends Cubit<DockingState> {
  final repo = GetIt.I.get<DockingRepo>();

  DockingCubit() : super(const DockingState());

  Timer? _pollTimer;
  int _pollCount = 0;

  static const _pollInterval = Duration(seconds: 15);

  int? _currentJobId;

  void startDocking(DockingRequestEntity request) {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;

    _startRealDocking(request);
  }

  Future<void> _startRealDocking(DockingRequestEntity request) async {
    emit(
      state.copyWith(
        status: DockingStatus.polling,
        request: request,
        logs: ['[${_ts()}] Submitting docking job...'],
        results: [],
      ),
    );

    final result = await repo.submitJob(request);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DockingStatus.idle,
            logs: [
              ...state.logs,
              '[${_ts()}] Failed: ${failure.message}',
            ],
          ),
        );
      },
      (job) {
        _currentJobId = job.jobId;
        emit(
          state.copyWith(
            logs: [
              ...state.logs,
              '[${_ts()}] Job submitted. ID: ${job.jobId}, Status: ${job.status}',
            ],
          ),
        );
        _pollReal();
        _pollTimer = Timer.periodic(_pollInterval, (_) => _pollReal());
      },
    );
  }

  Future<void> _pollReal() async {
    if (isClosed || _currentJobId == null) return;
    _pollCount++;

    emit(
      state.copyWith(
        logs: [
          ...state.logs,
          '[${_ts()}] Polling status... (poll $_pollCount)',
        ],
      ),
    );

    final result = await repo.getJobDetails(_currentJobId!);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            logs: [
              ...state.logs,
              '[${_ts()}] Status check failed: ${failure.message}',
            ],
          ),
        );
      },
      (job) {
        if (job.status == 'completed') {
          _cancelTimer();
          final results = [
            DockingEntity(
              id: job.jobId.toString(),
              targetId: job.inputs?.protein ?? 'Unknown',
              targetName: job.inputs?.protein ?? 'Unknown',
              jobId: 'JOB-${job.jobId}',
              createdAt: job.createdAt ?? DateTime.now(),
              vinaScore: (job.results?.vinaScores.isNotEmpty == true)
                  ? job.results!.vinaScores
                      .reduce((a, b) => a < b ? a : b)
                  : 0.0,
            ),
          ];
          emit(
            state.copyWith(
              status: DockingStatus.completed,
              logs: [
                ...state.logs,
                '[${_ts()}] Job completed.',
              ],
              results: results,
            ),
          );
        } else if (job.status == 'failed') {
          _cancelTimer();
          emit(
            state.copyWith(
              status: DockingStatus.idle,
              logs: [
                ...state.logs,
                '[${_ts()}] Job failed.',
              ],
            ),
          );
        } else {
          emit(
            state.copyWith(
              logs: [
                ...state.logs,
                '[${_ts()}] Status: ${job.status}...',
              ],
            ),
          );
        }
      },
    );
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;
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
