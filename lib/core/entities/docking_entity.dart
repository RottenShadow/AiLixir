import 'package:ailixir/core/entities/docking_score_entity.dart';

class DockingEntity {
  final String id;
  final String targetId;
  final String targetName;
  final String jobId;
  final DateTime createdAt;
  final double vinaScore;
  final List<DockingScoreEntity> scores;
  final String? downloadUrl;

  const DockingEntity({
    required this.id,
    required this.targetId,
    required this.targetName,
    required this.jobId,
    required this.createdAt,
    required this.vinaScore,
    this.scores = const [],
    this.downloadUrl,
  });

  static List<DockingEntity> createFakeData() {
    final sampleScores = [
      const DockingScoreEntity(
        affinity: -10.4, inter: -8.802, intra: -0.354, torsions: 1.495, unbound: -0.354,
      ),
      const DockingScoreEntity(
        affinity: -9.8, inter: -8.655, intra: -0.258, torsions: 1.454, unbound: -0.354,
      ),
    ];
    return [
      DockingEntity(
        id: '1',
        targetId: '6LU7',
        targetName: 'SARS-CoV-2 Mpro',
        jobId: 'JOB-1234-44712',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        vinaScore: -10.4,
        scores: sampleScores,
      ),
      DockingEntity(
        id: '2',
        targetId: '1AKI',
        targetName: 'Lysozyme',
        jobId: 'JOB-1234-45111',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        vinaScore: -9.8,
        scores: sampleScores,
      ),
      DockingEntity(
        id: '3',
        targetId: '3N75',
        targetName: 'BACE1',
        jobId: 'JOB-1234-47801',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        vinaScore: -8.5,
        scores: sampleScores,
      ),
    ];
  }
}
