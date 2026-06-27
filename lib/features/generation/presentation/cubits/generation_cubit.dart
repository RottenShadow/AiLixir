import 'dart:async';
import 'package:ailixir/core/entities/generation_files_entity.dart';
import 'package:ailixir/core/entities/generation_request_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/features/generation/data/repos/generation_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'generation_state.dart';

class GenerationCubit extends Cubit<GenerationState> {
  final repo = GetIt.I.get<GenerationRepo>();

  GenerationCubit() : super(const GenerationState());

  Timer? _pollTimer;
  int _pollCount = 0;

  static const _pollInterval = Duration(seconds: 15);
  static const _maxPollAttempts = 3;

  String? _currentJobId;

  void startGeneration(GenerationRequestEntity request) {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;

    _startRealGeneration(request);
  }

  Future<void> _startRealGeneration(GenerationRequestEntity request) async {
    emit(
      state.copyWith(
        status: GenerationStatus.polling,
        request: request,
        logs: ['[${_timestamp()}] Submitting generation job...'],
        results: [],
      ),
    );

    final result = await repo.submitJob(request);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: GenerationStatus.idle,
            logs: [
              ...state.logs,
              '[${_timestamp()}] Failed: ${failure.message}',
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
              '[${_timestamp()}] Job submitted. ID: ${job.jobId}, Status: ${job.status}',
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

    if (_pollCount > _maxPollAttempts) {
      _cancelTimer();
      emit(
        state.copyWith(
          status: GenerationStatus.idle,
          logs: [
            ...state.logs,
            '[${_timestamp()}] Max polling attempts reached ($_maxPollAttempts). Returning to idle. You can check progress in history.',
          ],
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        logs: [
          ...state.logs,
          '[${_timestamp()}] Polling status... (poll $_pollCount)',
        ],
      ),
    );

    final result = await repo.getJobStatus(_currentJobId!);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            logs: [
              ...state.logs,
              '[${_timestamp()}] Status check failed: ${failure.message}',
            ],
          ),
        );
      },
      (job) {
        if (job.status == 'completed') {
          _cancelTimer();
          _fetchResults();
        } else if (job.status == 'failed') {
          _cancelTimer();
          emit(
            state.copyWith(
              status: GenerationStatus.idle,
              logs: [...state.logs, '[${_timestamp()}] Job failed.'],
            ),
          );
        } else {
          emit(
            state.copyWith(
              logs: [
                ...state.logs,
                '[${_timestamp()}] Status: ${job.status}...',
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _fetchResults() async {
    if (_currentJobId == null) return;

    emit(
      state.copyWith(
        logs: [...state.logs, '[${_timestamp()}] Fetching results...'],
      ),
    );

    final result = await repo.getJobResults(_currentJobId!);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: GenerationStatus.idle,
            logs: [
              ...state.logs,
              '[${_timestamp()}] Failed to fetch results: ${failure.message}',
            ],
          ),
        );
      },
      (generationResult) {
        emit(
          state.copyWith(
            status: GenerationStatus.completed,
            logs: [
              ...state.logs,
              '[${_timestamp()}] Results received. ${generationResult.ligands.length} ligands.',
            ],
            results: generationResult.ligands,
            files: generationResult.files,
          ),
        );
      },
    );
  }

  void reset() {
    _cancelTimer();
    _pollCount = 0;
    _currentJobId = null;
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
