import 'package:ailixir/features/admet/data/models/admet_smile_model.dart';

class AdmetResult {
  final bool success;
  final List<AdmetSmileModel> data;
  const AdmetResult({required this.success, required this.data});
}
