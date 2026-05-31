part of 'admet_cubit.dart';

sealed class AdmetState {
  final List<String> logs;
  const AdmetState({this.logs = const []});
}

final class AdmetIdle extends AdmetState {
  const AdmetIdle({super.logs});
}

final class AdmetLoading extends AdmetState {
  const AdmetLoading({super.logs});
}

final class AdmetSuccess extends AdmetState {
  final AdmetPredictResponseEntity response;
  const AdmetSuccess({required this.response, super.logs});
}

final class AdmetError extends AdmetState {
  final String message;
  const AdmetError({required this.message, super.logs});
}
