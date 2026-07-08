part of 'generation_cubit.dart';

enum GenerationStatus { idle, polling, completed }

@immutable
class GenerationState {
  final GenerationStatus status;
  final GenerationRequestEntity? request;
  final List<String> logs;
  final List<LigandEntity> results;
  final GenerationFilesEntity? files;

  const GenerationState({
    this.status = GenerationStatus.idle,
    this.request,
    this.logs = const [],
    this.results = const [],
    this.files,
  });

  GenerationState copyWith({
    GenerationStatus? status,
    GenerationRequestEntity? request,
    List<String>? logs,
    List<LigandEntity>? results,
    GenerationFilesEntity? files,
  }) {
    return GenerationState(
      status: status ?? this.status,
      request: request ?? this.request,
      logs: logs ?? this.logs,
      results: results ?? this.results,
      files: files ?? this.files,
    );
  }
}
