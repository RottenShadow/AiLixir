import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/admet/data/models/admet_result.dart';
import 'package:ailixir/features/admet/data/models/admet_smile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

class AdmetRepo {
  final DioService dioService = GetIt.I.get<DioService>();

  Future<AdmetResult> postCompounds(String data) async {
    var res = await safeApiCall(() async {
      return await dioService.post(
        endpoint: "${AppEndpoints.baseUrl}scientists/",
        data: data,
        //TODO: FIX THIS URL
      );
    });
    Map<String, dynamic> dat = {};
    res.fold((e) {}, (s) {
      dat = s;
    });
    return getResultFromJson(dat);
  }

  AdmetResult getResultFromJson(Map<String, dynamic> json) {
    List<AdmetSmileModel> data = [];
    for (Map<String, dynamic> result in json["data"]) {
      AdmetSmileModel model = AdmetSmileModel(
        smiles: result["smiles"],
        absorption: result["absorption"],
        distribution: result["distribution"],
        metabolism: result["metabolism"],
        excretion: result["excretion"],
        toxicity: result["toxicity"],
      );
      data.add(model);
    }
    return AdmetResult(success: json["success"], data: data);
  }
}
