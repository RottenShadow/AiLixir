import 'package:ailixir/features/awards/data/models/award_model.dart';
import 'package:ailixir/features/awards/presentation/cubits/award_cubit.dart';

class AwardPackage {
  final AwardModel award;
  final AwardsCubit cubit;
  const AwardPackage({required this.award, required this.cubit});
}
