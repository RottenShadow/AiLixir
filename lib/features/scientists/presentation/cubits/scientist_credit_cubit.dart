import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/presentation/factories/award_factory.dart';
import 'package:ailixir/features/scientists/data/factories/scientist_factory.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:ailixir/features/scientists/data/repos/scientist_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'scientist_credit_state.dart';

class ScientistCreditCubit extends Cubit<ScientistCreditState> {
  ScientistCreditCubit() : super(ScientistCreditInitial());

  final ScientistRepo _repo = ScientistRepo(
    dioService: GetIt.I.get<DioService>(),
  );
  Future<void> getScientists() async {
    emit(ScientistCreditLoading());
    var res = await _repo.getScientists();
    res.fold(
      (_) {
        emit(ScientistCreditError());
      },
      (jsonData) {
        emit(
          ScientistCreditSuccess(
            res: ScientistFactory.getScientistsFromJson(jsonData),
          ),
        );
      },
    );
  }

  Future<void> getTestScientists() async {
    emit(ScientistCreditLoading());
    var res = await _repo.getTestScientists();
    res.fold(
      (_) {
        emit(ScientistCreditError());
      },
      (jsonData) {
        emit(
          ScientistCreditSuccess(
            res: ScientistFactory.getScientistsFromJson(jsonData),
          ),
        );
      },
    );
  }

  Future<List<AwardModel>> getAwards(int sciId) async {
    var res = await _repo.getAwards(sciId);
    return res.fold(
      (_) {
        return [];
      },
      (jsonData) {
        return AwardFactory.getAwardsFromScientistJson(jsonData);
      },
    );
  }

  Future<List<AwardModel>> getTestAwards(int sciId) async {
    var res = await _repo.getTestAwards(sciId);
    return res.fold(
      (_) {
        return [];
      },
      (jsonData) {
        return AwardFactory.getAwardsFromScientistJson(jsonData);
      },
    );
  }
}
