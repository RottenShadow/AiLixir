part of 'dr_quick_cubit.dart';

sealed class DrQuickState {
  final List<String> logs;
  const DrQuickState({this.logs = const []});
}

final class DrQuickIdle extends DrQuickState {
  const DrQuickIdle({super.logs});
}

final class DrQuickPolling extends DrQuickState {
  const DrQuickPolling({super.logs});
}

final class DrQuickSuccess extends DrQuickState {
  final DrugRepurposingTargetsResponseEntity response;
  const DrQuickSuccess({required this.response, super.logs});
}

final class DrQuickError extends DrQuickState {
  final String message;
  const DrQuickError({required this.message, super.logs});
}
