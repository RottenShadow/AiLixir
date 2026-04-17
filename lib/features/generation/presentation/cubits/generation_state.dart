part of 'generation_cubit.dart';

enum GenerationStatus { idle, polling, completed }

@immutable
class GenerationState {
  final GenerationStatus status;
  final GenerationRequestEntity? request;
  final List<String> logs;
  final List<LigandEntity> results;

  const GenerationState({
    this.status = GenerationStatus.idle,
    this.request,
    this.logs = const [],
    this.results = const [],
  });

  GenerationState copyWith({
    GenerationStatus? status,
    GenerationRequestEntity? request,
    List<String>? logs,
    List<LigandEntity>? results,
  }) {
    return GenerationState(
      status: status ?? this.status,
      request: request ?? this.request,
      logs: logs ?? this.logs,
      results: results ?? this.results,
    );
  }
}
