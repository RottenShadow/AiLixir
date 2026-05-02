part of 'dr_full_cubit.dart';

sealed class DrFullState {
  final List<String> logs;
  const DrFullState({this.logs = const []});
}

final class DrFullIdle extends DrFullState {
  const DrFullIdle({super.logs});
}

final class DrFullLoading extends DrFullState {
  const DrFullLoading({super.logs});
}

final class DrFullSuccess extends DrFullState {
  final DrugRepurposingScreenResponseEntity response;
  const DrFullSuccess({required this.response, super.logs});
}

final class DrFullError extends DrFullState {
  final String message;
  const DrFullError({required this.message, super.logs});
}
