import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ailixir/features/chemical_search/domain/entities/chemical_search_entity.dart';

part 'chemical_search_state.dart';

class ChemicalSearchCubit extends Cubit<ChemicalSearchState> {
  final List<String> _logs = [];
  final bool fullRag;

  ChemicalSearchCubit({this.fullRag = false}) : super(const ChemicalSearchIdle());

  Future<void> search({
    required String smiles,
    int topK = 3,
  }) async {
    _logs.clear();
    _logs.add('[${_ts()}] Initializing chemical similarity search...');
    emit(ChemicalSearchLoading(smiles: smiles, logs: List.unmodifiable(_logs)));

    await Future.delayed(const Duration(milliseconds: 500));

    _logs.add(
      '[${_ts()}] Searching using ${fullRag ? "full RAG (LLM)" : "fast retrieval"} mode...',
    );
    emit(ChemicalSearchLoading(smiles: smiles, logs: List.unmodifiable(_logs)));

    await Future.delayed(const Duration(milliseconds: 400));

    _logs.add('[${_ts()}] Querying FAISS-IVF index with Morgan fingerprints...');
    emit(ChemicalSearchLoading(smiles: smiles, logs: List.unmodifiable(_logs)));

    await Future.delayed(const Duration(milliseconds: 300));

    final response = _generateDummyData(smiles, topK);

    _logs.add('[${_ts()}] Found ${response.results.length} similar compounds.');
    emit(ChemicalSearchSuccess(
      response: response,
      smiles: smiles,
      logs: List.unmodifiable(_logs),
    ));
  }

  ChemicalSearchResponseEntity _generateDummyData(
    String querySmiles,
    int topK,
  ) {
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
        smiles: 'C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(CC(C(F)(F)F)(C(F)(F)F)O)O',
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
        smiles: 'C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(=O)CC(C(F)(F)F)(C(F)(F)F)O',
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
        smiles: 'C1=CC(=CC=C1C(CC(C(F)(F)F)(C(F)(F)F)O)O)C(=O)CC(C(F)(F)F)O',
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

    return ChemicalSearchResponseEntity(
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
    );
  }

  void reset() {
    _logs.clear();
    emit(const ChemicalSearchIdle());
  }

  String _ts() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}:'
        '${n.second.toString().padLeft(2, '0')}';
  }
}
