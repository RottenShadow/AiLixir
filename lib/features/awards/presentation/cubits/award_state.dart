part of 'award_cubit.dart';

@immutable
sealed class AwardState {}

final class AwardInitial extends AwardState {}

final class AwardLoading extends AwardState {}

final class AwardSuccess extends AwardState {
  final List<AwardModel> awards;
  AwardSuccess({required this.awards});
}

final class AwardError extends AwardState {}
