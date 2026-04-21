import 'package:ailixir/features/similarity/data/models/compound.dart';

class SimilarityResultModel {
  final String query_smiles;
  final int total_results;
  final List<Compound> results;
  const SimilarityResultModel({
    required this.query_smiles,
    required this.total_results,
    required this.results,
  });
}
