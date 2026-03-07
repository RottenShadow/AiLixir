part of 'award_cubit.dart';

@immutable
sealed class AwardState {
  final List<AwardModel> awards;
  const AwardState._def({this.awards = const []});
  const AwardState() : this._def();
}

final class AwardInitial extends AwardState {}

final class AwardLoading extends AwardState {}

final class AwardSuccess extends AwardState {
  const AwardSuccess({required List<AwardModel> awardList})
    : super._def(awards: awardList);
}

final class AwardError extends AwardState {}
