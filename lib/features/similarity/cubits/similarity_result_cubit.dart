import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/features/similarity/data/models/compound.dart';
import 'package:ailixir/features/similarity/data/models/similarity_result_model.dart';
import 'package:ailixir/features/similarity/data/repos/similarity_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'similarity_result_state.dart';

class SimilarityResultCubit extends Cubit<SimilarityResultState> {
  SimilarityResultCubit() : super(SimilarityResultInitial());

  final SimilarityRepo _repo = SimilarityRepo(
    dioService: GetIt.I.get<DioService>(),
  );
  Future<void> getSimilar(String smiles) async {
    emit(SimilarityResultLoading());
    var res = await _repo.getSimilar(smiles);
    res.fold(
      (_) {
        emit(SimilarityResultError());
      },
      (jsonData) {
        emit(SimilarityResultSuccess(data: getFromJson(jsonData)));
      },
    );
  }

  Future<void> getTestSimilar(String smiles) async {
    emit(SimilarityResultLoading());
    var res = await _repo.getTestSimilar(smiles);
    res.fold(
      (_) {
        emit(SimilarityResultError());
      },
      (jsonData) {
        emit(SimilarityResultSuccess(data: getFromJson(jsonData)));
      },
    );
  }

  SimilarityResultModel getFromJson(Map<String, dynamic> jsonData) {
    List<Compound> compounds = [];
    for (Map<String, dynamic> result in jsonData["results"]) {
      compounds.add(
        Compound(
          name: result["name"],
          cid: result["cid"],
          score: result["similarity_score"],
          smiles: result["smiles"],
          imageUrl: result["image"],
          explanation: result["explanation"],
        ),
      );
    }
    return SimilarityResultModel(
      query_smiles: jsonData["query_smiles"],
      total_results: jsonData["total_results"],
      results: compounds,
    );
  }
}
