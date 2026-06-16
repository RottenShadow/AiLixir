import 'dart:async';
import 'package:ailixir/features/drug_repurposing/data/repositories/drug_repurposing_repository.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_screen_request_entity.dart';
import 'package:ailixir/features/drug_repurposing/domain/entities/drug_repurposing_screen_response_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dr_full_state.dart';

class DrFullCubit extends Cubit<DrFullState> {
  final DrugRepurposingRepository _repository;

  DrFullCubit({required DrugRepurposingRepository repository})
    : _repository = repository,
      super(const DrFullIdle());

  Timer? _pollTimer;
  int _pollCount = 0;
  int? _currentJobId;

  static const _pollInterval = Duration(seconds: 15);

  Future<void> screenDrugs({
    required String diseaseName,
    required List<String> knownDrugs,
    required double minScore,
    required int topNTargets,
  }) async {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;

    emit(DrFullPolling(logs: ['[${_ts()}] Submitting screening job...']));

    final request = DrugRepurposingScreenRequestEntity(
      diseaseName: diseaseName,
      knownDrugs: knownDrugs,
      minScore: minScore,
      topNTargets: topNTargets,
    );

    final result = await _repository.submitScreenJob(request);
    result.fold(
      (failure) {
        emit(
          DrFullError(
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
        emit(DrFullPolling(logs: logs));
        _pollScreen();
        _pollTimer = Timer.periodic(_pollInterval, (_) => _pollScreen());
      },
    );
  }

  Future<void> _pollScreen() async {
    if (isClosed || _currentJobId == null) return;
    _pollCount++;

    emit(
      DrFullPolling(
        logs: [
          ...(state.logs),
          '[${_ts()}] Polling status... (poll $_pollCount)',
        ],
      ),
    );

    final result = await _repository.getScreenJobStatus(_currentJobId!);
    result.fold(
      (failure) {
        emit(
          DrFullError(
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
              DrFullSuccess(
                response: output,
                logs: [
                  ...(state.logs),
                  '[${_ts()}] ✓ Screened ${output.totalPairsEvaluated} drug-target pairs.',
                  '[${_ts()}] ✓ Identified ${output.topCandidates.length} top candidates.',
                  '[${_ts()}] ✓ Full screening complete.',
                ],
              ),
            );
          } else {
            emit(
              DrFullError(
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
            DrFullError(
              message: 'Screening job failed.',
              logs: [
                ...(state.logs),
                '[${_ts()}] ✗ Job failed.',
              ],
            ),
          );
        } else {
          emit(
            DrFullPolling(
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
    if (state is DrFullSuccess) {
      emit(
        DrFullSuccess(
          response: (state as DrFullSuccess).response,
          logs: [],
        ),
      );
    } else if (state is DrFullError) {
      emit(
        DrFullError(
          message: (state as DrFullError).message,
          logs: [],
        ),
      );
    } else {
      emit(const DrFullIdle());
    }
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;
    emit(const DrFullIdle());
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
