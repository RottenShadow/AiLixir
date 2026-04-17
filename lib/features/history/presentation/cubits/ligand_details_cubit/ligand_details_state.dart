part of 'ligand_details_cubit.dart';

@immutable
sealed class LigandDetailsState {}

final class LigandDetailsInitial extends LigandDetailsState {}

final class LigandDetailsLoading extends LigandDetailsState {}

final class LigandDetailsLoaded extends LigandDetailsState {
  final LigandDetailsEntity details;
  LigandDetailsLoaded({required this.details});
}

final class LigandDetailsError extends LigandDetailsState {
  final String message;
  LigandDetailsError({required this.message});
}
