part of 'scientist_credit_cubit.dart';

@immutable
sealed class ScientistCreditState {}

class ScientistCreditInitial extends ScientistCreditState {}

class ScientistCreditLoading extends ScientistCreditState {}

class ScientistCreditError extends ScientistCreditState {}

class ScientistCreditSuccess extends ScientistCreditState {
  final List<ScientistModel> res;
  ScientistCreditSuccess({required this.res});
}
