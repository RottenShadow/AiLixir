import 'package:dartz/dartz.dart';
import 'package:ailixir/core/errors/failure.dart';
import 'package:ailixir/core/services/api/app_endpoints.dart';
import 'package:ailixir/core/services/api/dio_service.dart';
import 'package:ailixir/core/utils/app_feature_flag.dart';
import 'package:ailixir/core/utils/helper_functions/safe_api_call.dart';
import 'package:ailixir/features/chemical_search/data/models/chemical_search_response_model.dart';
import 'package:ailixir/features/chemical_search/domain/entities/chemical_search_entity.dart';

class ChemicalSearchRepo {
  final DioService dioService;

  ChemicalSearchRepo({required this.dioService});

  Future<Either<Failure, ChemicalSearchResponseEntity>> search({
    required String smiles,
    int topK = 3,
    bool fullRag = false,
  }) async {
    if (AppFeatureFlag.useFakeChemicalSearch) {
      return _fakeSearch(smiles, topK, fullRag);
    }
    return safeApiCall(() async {
      final endpoint = fullRag
          ? AppEndpoints.chemicalSearchFullRag
          : AppEndpoints.chemicalSearch;
      final response = await dioService.post(
        endpoint: endpoint,
        data: {'smiles': smiles, 'top_k': topK},
      );
      return ChemicalSearchResponseModel.fromJson(
        response as Map<String, dynamic>,
      ).toEntity();
    });
  }

  Future<Either<Failure, ChemicalSearchResponseEntity>> _fakeSearch(
    String querySmiles,
    int topK,
    bool fullRag,
  ) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final results = <ChemicalSearchResultEntity>[
      ChemicalSearchResultEntity(
        smiles: querySmiles,
        similarityScore: 1.0,
        rank: 1,
        explanation: fullRag
            ? 'Query and Match: Identical compound.\n'
                'Similarity Score: 1.000\n\n'
                'Explanation: The structure is an exact match.'
            : null,
      ),
      ChemicalSearchResultEntity(
        smiles:
            'C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(CC(C(F)(F)F)(C(F)(F)F)O)O',
        similarityScore: 0.9951,
        rank: 2,
        explanation: fullRag
            ? 'Query: Contains C=O ketone group | Match: C-OH alcohol group\n'
                'Similarity Score: 0.995\n\n'
                'Explanation: This match represents a reduction of the ketone '
                'group (C=O) in the query to a secondary alcohol group (C-OH). '
                'The rest of the molecular framework remains identical.'
            : null,
      ),
      ChemicalSearchResultEntity(
        smiles:
            'C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(=O)CC(C(F)(F)F)(C(F)(F)F)O',
        similarityScore: 0.9823,
        rank: 3,
        explanation: fullRag
            ? 'Query: C1=CC...C(=O)... | Match: C1=CC...C(=O)...\n'
                'Similarity Score: 0.982\n\n'
                'Explanation: This match preserves the ketone bridge and both '
                'fluorinated side chains with slight conformational differences '
                'in the aromatic ring substitution pattern.'
            : null,
      ),
      ChemicalSearchResultEntity(
        smiles:
            'C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(=O)CC(C(F)(F)F)O',
        similarityScore: 0.8947,
        rank: 4,
        explanation: fullRag
            ? 'Query: Two HFIP groups | Match: One HFIP group\n'
                'Similarity Score: 0.895\n\n'
                'Explanation: This compound retains the core aromatic structure '
                'and one hexafluoroisopropanol (HFIP) group but is missing the '
                'second HFIP group, resulting in moderate similarity.'
            : null,
      ),
      ChemicalSearchResultEntity(
        smiles: 'c1ccccc1',
        similarityScore: 0.3210,
        rank: 5,
        explanation: fullRag
            ? 'Query: Complex fluorinated compound | Match: Benzene\n'
                'Similarity Score: 0.321\n\n'
                'Explanation: Only the aromatic core is shared. All functional '
                'group extensions are absent in the match.'
            : null,
      ),
    ];

    return Right(
      ChemicalSearchResponseEntity(
        results: results.take(topK).toList(),
        isFullRag: fullRag,
        metadata: {
          'search_time_ms': fullRag ? 1200 : 45,
          'compounds_searched': 1000000,
          'endpoint': fullRag ? 'full-rag' : 'retrieval-only',
          if (fullRag) ...{
            'model': 'Llama-3.1-8B',
            'llm_time_ms': 850,
            'total_time_ms': 1200,
          },
        },
      ),
    );
  }
}
