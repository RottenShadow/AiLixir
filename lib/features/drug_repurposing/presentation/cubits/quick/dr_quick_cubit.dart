import 'dart:async';
import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_targets_response_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dr_quick_state.dart';

class DrQuickCubit extends Cubit<DrQuickState> {
  final DrugRepurposingRepository _repository;

  DrQuickCubit({required DrugRepurposingRepository repository})
    : _repository = repository,
      super(const DrQuickIdle());

  Timer? _pollTimer;
  int _pollCount = 0;
  int? _currentJobId;

  static const _pollInterval = Duration(seconds: 15);

  Future<void> getTargets(String diseaseName) async {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;

    emit(DrQuickPolling(logs: ['[${_ts()}] Submitting target lookup job...']));

    final result = await _repository.submitTargetsJob(diseaseName: diseaseName);
    result.fold(
      (failure) {
        emit(
          DrQuickError(
            message: failure.message,
            logs: ['[${_ts()}] Failed: ${failure.message}'],
          ),
        );
      },
      (job) {
        _currentJobId = job.jobId;
        final logs = [
          '[${_ts()}] Job submitted. ID: ${job.jobId}, Status: ${job.status}',
        ];
        emit(DrQuickPolling(logs: logs));
        _pollTargets();
        _pollTimer = Timer.periodic(_pollInterval, (_) => _pollTargets());
      },
    );
  }

  Future<void> _pollTargets() async {
    if (isClosed || _currentJobId == null) return;
    _pollCount++;

    emit(
      DrQuickPolling(
        logs: [
          ...(state.logs),
          '[${_ts()}] Polling status... (poll $_pollCount)',
        ],
      ),
    );

    final result = await _repository.getTargetsJobStatus(_currentJobId!);
    result.fold(
      (failure) {
        emit(
          DrQuickError(
            message: failure.message,
            logs: [
              ...(state.logs),
              '[${_ts()}] Status check failed: ${failure.message}',
            ],
          ),
        );
      },
      (job) {
        if (job.status == 'completed') {
          _cancelTimer();
          final output = job.output;
          if (output != null) {
            emit(
              DrQuickSuccess(
                response: output,
                logs: [
                  ...(state.logs),
                  '[${_ts()}] ✓ Found ${output.totalTargets} molecular targets.',
                  '[${_ts()}] ✓ Target discovery complete.',
                ],
              ),
            );
          } else {
            emit(
              DrQuickError(
                message: 'Job completed but no output data.',
                logs: [
                  ...(state.logs),
                  '[${_ts()}] ✗ Job completed but output is empty.',
                ],
              ),
            );
          }
        } else if (job.status == 'failed') {
          _cancelTimer();
          emit(
            DrQuickError(
              message: 'Target lookup job failed.',
              logs: [
                ...(state.logs),
                '[${_ts()}] ✗ Job failed.',
              ],
            ),
          );
        } else {
          emit(
            DrQuickPolling(
              logs: [
                ...(state.logs),
                '[${_ts()}] Status: ${job.status}...',
              ],
            ),
          );
        }
      },
    );
  }

  void clearLogs() {
    if (state is DrQuickSuccess) {
      emit(
        DrQuickSuccess(
          response: (state as DrQuickSuccess).response,
          logs: [],
        ),
      );
    } else if (state is DrQuickError) {
      emit(
        DrQuickError(
          message: (state as DrQuickError).message,
          logs: [],
        ),
      );
    } else {
      emit(const DrQuickIdle());
    }
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;
    emit(const DrQuickIdle());
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
