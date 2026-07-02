enum MdStatus { completed, running, failed }

class MdResultMeta {
  final String? downloadUrl;
  final String? downloadAnalysisUrl;

  const MdResultMeta({this.downloadUrl, this.downloadAnalysisUrl});
}

class MdAnalysisMeta {
  final String? downloadUrl;
  final List<String> outputs;

  const MdAnalysisMeta({this.downloadUrl, this.outputs = const []});
}

class MdEntity {
  final String id;
  final String simulationTask;
  final DateTime createdAt;
  final String forcefield;
  final String duration;
  final MdStatus status;
  final String? proteinName;
  final String? ligandName;
  final String? remoteStatus;
  final String? errorMessage;
  final MdResultMeta? resultMeta;
  final MdAnalysisMeta? analysisMeta;

  const MdEntity({
    required this.id,
    required this.simulationTask,
    required this.createdAt,
    required this.forcefield,
    required this.duration,
    required this.status,
    this.proteinName,
    this.ligandName,
    this.remoteStatus,
    this.errorMessage,
    this.resultMeta,
    this.analysisMeta,
  });

  static List<MdEntity> createFakeData() {
    return [
      MdEntity(
        id: '1',
        simulationTask: 'ACE2_spike_interaction',
        createdAt: DateTime(2023, 10, 24, 14, 20),
        forcefield: 'AMBER1\n4SB',
        duration: '100\nns',
        status: MdStatus.completed,
        proteinName: '4w52.pdb',
        ligandName: 'ligand.pdb',
        resultMeta: const MdResultMeta(
          downloadUrl: '/download/fake-1',
          downloadAnalysisUrl: '/download_analysis/fake-1',
        ),
      ),
      MdEntity(
        id: '2',
        simulationTask: 'B-DNA_solvated_box',
        createdAt: DateTime(2023, 10, 22, 9, 15),
        forcefield: 'CHARMM\n36m',
        duration: '50 ns',
        status: MdStatus.completed,
        proteinName: '1bna.pdb',
        ligandName: 'stl.pdb',
        resultMeta: const MdResultMeta(
          downloadUrl: '/download/fake-2',
          downloadAnalysisUrl: '/download_analysis/fake-2',
        ),
      ),
    ];
  }
}
