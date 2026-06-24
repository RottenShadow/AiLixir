part of 'drug_repurposing_cubit.dart';

enum DrugRepurposingSubTab { targets, screen }

@immutable
sealed class DrugRepurposingState {}

final class DrugRepurposingInitial extends DrugRepurposingState {}

final class DrugRepurposingLoading extends DrugRepurposingState {}

final class DrugRepurposingLoaded extends DrugRepurposingState {
  final List<DrugRepurposingEntity> targets;
  final List<DrugRepurposingEntity> screen;
  final DrugRepurposingSubTab selectedSubTab;

  DrugRepurposingLoaded({
    required this.targets,
    required this.screen,
    required this.selectedSubTab,
  });
}

final class DrugRepurposingLoadingMore extends DrugRepurposingState {
  final List<DrugRepurposingEntity> targets;
  final List<DrugRepurposingEntity> screen;
  final DrugRepurposingSubTab selectedSubTab;

  DrugRepurposingLoadingMore({
    required this.targets,
    required this.screen,
    required this.selectedSubTab,
  });
}

final class DrugRepurposingError extends DrugRepurposingState {
  final String message;
  DrugRepurposingError({required this.message});
}
