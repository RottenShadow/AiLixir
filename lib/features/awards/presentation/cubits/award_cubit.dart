import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/data/repos/award_repo.dart';
import 'package:ailixir/features/awards/presentation/factories/award_factory.dart';
import 'package:ailixir/features/scientists/presentation/factories/scientist_factory.dart';
import 'package:ailixir/features/scientists/presentation/models/scientist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';

part 'award_state.dart';

class AwardsCubit extends Cubit<AwardState> {
  final _repo = GetIt.I.get<AwardRepo>();
  AwardsCubit() : super(AwardInitial());

  Future<void> getAwards() async {
    emit(AwardLoading());
    var res = await _repo.getAwards();
    res.fold(
      (_) {
        emit(AwardError());
      },
      (jsonData) {
        emit(AwardSuccess(awards: AwardFactory.getAwardsFromJson(jsonData)));
      },
    );
  }

  Future<List<ScientistModel>> getScientists(int awardId) async {
    var res = await _repo.getScientists(awardId);
    return res.fold(
      (_) {
        return [];
      },
      (jsonData) {
        return ScientistFactory.getScientistsFromAwardJson(jsonData);
      },
    );
  }

  Future<void> getTestAwards([String? query]) async {
    emit(AwardLoading());
    await Future.delayed(Duration(milliseconds: 22));
    var res = _repo.getTestAwards();
    res.fold(
      (_) {
        emit(AwardError());
      },
      (jsonData) {
        emit(AwardSuccess(awards: AwardFactory.getAwardsFromJson(jsonData)));
      },
    );
  }

  Future<List<ScientistModel>> getTestScientists(int awardId) async {
    var res = await _repo.getTestScientists(awardId);
    return res.fold(
      (_) {
        return [];
      },
      (jsonData) {
        return ScientistFactory.getScientistsFromAwardJson(jsonData);
      },
    );
  }
}
