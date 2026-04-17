import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/data/repos/award_repo.dart';
import 'package:ailixir/features/awards/presentation/factories/award_factory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';

part 'award_state.dart';

class AwardsCubit extends Cubit<AwardState> {
  final _repo = GetIt.I.get<AwardRepo>();
  AwardsCubit() : super(AwardInitial());

  Future<void> getAwards(String query) async {
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
}
