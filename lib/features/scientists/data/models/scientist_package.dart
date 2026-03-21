import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:ailixir/features/scientists/presentation/cubits/scientist_credit_cubit.dart';

class ScientistPackage {
  final ScientistCreditCubit cubit;
  final ScientistModel scientist;
  const ScientistPackage({required this.scientist, required this.cubit});
}
