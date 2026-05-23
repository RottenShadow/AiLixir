import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/data/repos/award_repo.dart';
import 'package:ailixir/features/awards/presentation/factories/award_factory.dart';
import 'package:ailixir/features/scientists/data/factories/scientist_factory.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';

part 'award_state.dart';

class AwardsCubit extends Cubit<AwardState> {
  final _repo = GetIt.I.get<AwardRepo>();
  late final int maxPage;
  int currentPage = 1;
  AwardsCubit() : super(AwardInitial());

  Future<void> getAwards(int page) async {
    emit(AwardLoading());
    var res = await _repo.getAwards(page: page);
    res.fold(
      (_) {
        emit(AwardError());
      },
      (jsonData) {
        maxPage = jsonData["pagination"]["totalPages"];
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
        maxPage = jsonData["pagination"]["totalPages"];
        emit(AwardSuccess(awards: AwardFactory.getAwardsFromJson(jsonData)));
      },
    );
  }

  Future<List<AwardModel>> getPageAwards() async {
    if (currentPage == maxPage) {
      return [];
    }
    currentPage += 1;
    var res = await _repo.getAwards(page: currentPage);
    List<AwardModel> out = [];
    res.fold((_) {}, (jsonData) {
      out = AwardFactory.getAwardsFromJson(jsonData);
    });
    return out;
  }

  Future<List<AwardModel>> getPageTestAwards() async {
    await Future.delayed(Duration(milliseconds: 22));
    if (currentPage == maxPage) {
      return [];
    }
    print("hello");
    currentPage += 1;
    var res = _repo.getTestAwards(page: currentPage);
    List<AwardModel> out = [];
    res.fold((_) {}, (jsonData) {
      out = AwardFactory.getAwardsFromJson(jsonData);
    });
    return out;
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
