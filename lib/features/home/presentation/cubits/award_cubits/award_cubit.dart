import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/features/home/presentation/factories/award_factory.dart';
import 'package:ailixir/features/home/presentation/models/award_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';

part 'award_state.dart';

class AwardsCubit extends Cubit<AwardState> {
  final _service = GetIt.I.get<DioService>();
  AwardsCubit() : super(AwardInitial());

  Future<void> getAwards(String query) async {
    emit(AwardLoading());
    try {
      var res = await _service.get(
        endpoint: "${AppEndpoints.baseUrl}awards/$query",
      );
      emit(AwardSuccess(awardList: AwardFactory.getAwardsFromJson(res)));
    } catch (e) {
      emit(AwardError());
    }
  }
}
