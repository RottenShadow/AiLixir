import 'package:ailixir/features/chemical_search/data/models/chemical_search_result_model.dart';
import 'package:ailixir/features/chemical_search/domain/entities/chemical_search_entity.dart';

class ChemicalSearchResponseModel {
  final Map<String, dynamic> query;
  final List<ChemicalSearchResultModel> compounds;
  final Map<String, dynamic> metadata;

  const ChemicalSearchResponseModel({
    required this.query,
    required this.compounds,
    required this.metadata,
  });

  factory ChemicalSearchResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle both {success, data: {query, compounds, metadata}} and
    // {success, query, compounds, metadata} shapes.
    final d = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    return ChemicalSearchResponseModel(
      query: d['query'] as Map<String, dynamic>? ?? {},
      compounds: (d['compounds'] as List<dynamic>?)
              ?.map((e) =>
                  ChemicalSearchResultModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: d['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  ChemicalSearchResponseEntity toEntity() {
    return ChemicalSearchResponseEntity(
      results: compounds.map((e) => e.toEntity()).toList(),
      isFullRag: metadata['source'] == 'full_rag',
      metadata: metadata,
    );
  }
}
