enum DrugRepurposingType { targets, screen }

class DrugRepurposingHistoryTarget {
  final String symbol;
  final String name;
  final double score;
  final String uniprotId;
  final List<String> pdbIds;

  const DrugRepurposingHistoryTarget({
    required this.symbol,
    required this.name,
    required this.score,
    required this.uniprotId,
    required this.pdbIds,
  });
}

class DrugRepurposingHistoryCandidate {
  final String drugName;
  final String smiles;
  final String targetSymbol;
  final String uniprotId;
  final double bindingScore;
  final int rank;
  final String status;

  const DrugRepurposingHistoryCandidate({
    required this.drugName,
    required this.smiles,
    required this.targetSymbol,
    required this.uniprotId,
    required this.bindingScore,
    required this.rank,
    required this.status,
  });
}

class DrugRepurposingEntity {
  final String id;
  final DrugRepurposingType type;
  final String diseaseName;
  final String status;
  final DateTime createdAt;
  final int resultCount;
  final int? totalTargets;
  final List<DrugRepurposingHistoryTarget>? targets;
  final int? totalDrugsScreened;
  final int? totalPairsEvaluated;
  final List<DrugRepurposingHistoryCandidate>? topCandidates;

  const DrugRepurposingEntity({
    required this.id,
    required this.type,
    required this.diseaseName,
    required this.status,
    required this.createdAt,
    required this.resultCount,
    this.totalTargets,
    this.targets,
    this.totalDrugsScreened,
    this.totalPairsEvaluated,
    this.topCandidates,
  });

  static List<DrugRepurposingEntity> createFakeData() {
    return [
      DrugRepurposingEntity(
        id: '1',
        type: DrugRepurposingType.targets,
        diseaseName: 'Type 2 Diabetes',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        resultCount: 10,
        totalTargets: 10,
        targets: [
          const DrugRepurposingHistoryTarget(
            symbol: 'KCNJ11',
            name: 'potassium inwardly rectifying channel subfamily J member 11',
            score: 0.8651,
            uniprotId: 'Q14654',
            pdbIds: ['2UKM', '2UGY', '2UUG'],
          ),
          const DrugRepurposingHistoryTarget(
            symbol: 'ABCC8',
            name: 'ATP binding cassette subfamily C member 8',
            score: 0.8648,
            uniprotId: 'Q09428',
            pdbIds: [],
          ),
        ],
      ),
      DrugRepurposingEntity(
        id: '2',
        type: DrugRepurposingType.screen,
        diseaseName: 'Alzheimer Disease',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        resultCount: 200,
        totalDrugsScreened: 200,
        totalPairsEvaluated: 2000,
        topCandidates: [
          const DrugRepurposingHistoryCandidate(
            drugName: 'Drug_CHEMBL1754',
            smiles: 'CC1=C(C=C(C=C1)NC(=O)C2=CC=C(C=C2)Cl)Cl',
            targetSymbol: 'KCNJ11',
            uniprotId: 'Q14654',
            bindingScore: 0.9821,
            rank: 1,
            status: 'Potential Discovery',
          ),
        ],
      ),
    ];
  }
}
