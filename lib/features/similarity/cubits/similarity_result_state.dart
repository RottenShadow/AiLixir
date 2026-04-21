part of 'similarity_result_cubit.dart';

@immutable
class SimilarityResultState {}

class SimilarityResultInitial extends SimilarityResultState {}

class SimilarityResultLoading extends SimilarityResultState {}

class SimilarityResultError extends SimilarityResultState {}

class SimilarityResultSuccess extends SimilarityResultState {
  final SimilarityResultModel data;
  SimilarityResultSuccess({required this.data});
}
