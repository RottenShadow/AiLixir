class DockingEntity {
  final String id;
  final String targetId;
  final String targetName;
  final String jobId;
  final DateTime createdAt;
  final double vinaScore;

  const DockingEntity({
    required this.id,
    required this.targetId,
    required this.targetName,
    required this.jobId,
    required this.createdAt,
    required this.vinaScore,
  });

  static List<DockingEntity> createFakeData() {
    return [
      DockingEntity(
        id: '1',
        targetId: '6LU7',
        targetName: 'SARS-CoV-2 Mpro',
        jobId: 'JOB-1234-44712',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        vinaScore: -10.4,
      ),
      DockingEntity(
        id: '2',
        targetId: '1AKI',
        targetName: 'Lysozyme',
        jobId: 'JOB-1234-45111',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        vinaScore: -9.8,
      ),
      DockingEntity(
        id: '3',
        targetId: '3N75',
        targetName: 'BACE1',
        jobId: 'JOB-1234-47801',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        vinaScore: -8.5,
      ),
    ];
  }
}
