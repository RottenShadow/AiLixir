part of 'molecular_lab_cubit.dart';

@immutable
sealed class MolecularLabState {}

final class MolecularLabInitial extends MolecularLabState {}

final class MolecularLabLoaded extends MolecularLabState {
  final String pdbId;
  final DateTime
  timestamp; // To ensure state uniqueness if same PDB is reloaded

  MolecularLabLoaded({required this.pdbId, required this.timestamp});
}
