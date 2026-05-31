part of 'chemical_search_cubit.dart';

sealed class ChemicalSearchState {
  final String smiles;
  final List<String> logs;

  const ChemicalSearchState({this.smiles = '', this.logs = const []});
}

final class ChemicalSearchIdle extends ChemicalSearchState {
  const ChemicalSearchIdle({super.smiles, super.logs});
}

final class ChemicalSearchLoading extends ChemicalSearchState {
  const ChemicalSearchLoading({super.smiles, super.logs});
}

final class ChemicalSearchSuccess extends ChemicalSearchState {
  final ChemicalSearchResponseEntity response;

  const ChemicalSearchSuccess({
    required this.response,
    super.smiles,
    super.logs,
  });
}

final class ChemicalSearchError extends ChemicalSearchState {
  final String message;

  const ChemicalSearchError({
    required this.message,
    super.smiles,
    super.logs,
  });
}
