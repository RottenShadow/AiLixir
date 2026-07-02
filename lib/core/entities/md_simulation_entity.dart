/// Entity representing all inputs for a Molecular Dynamics simulation
/// based on the MD.py (Protein_ligand notebook) parameters.
class MdSimulationEntity {
  // ── Section 1: System Setup ──────────────────────────────────────────────
  final String proteinPdbPath;
  final String proteinPdbName; // display name (filename only)
  final String ligandPdbPath;
  final String ligandPdbName;
  final bool removeWaters;
  final bool addLigandHydrogens;
  final int systemTotalCharge; // slider -10 → +10

  // ── Section 2: Force Field & Solvation ──────────────────────────────────
  final String proteinForceField; // ff19SB | ff14SB
  final String ligandForceField; // GAFF2
  final String waterModel; // TIP3P | OPC
  final double boxSizePadding; // Å, 10–20

  // ── Section 3: Ions & Ionic Strength ────────────────────────────────────
  final String saltType; // NaCl | KCl
  final double concentration; // Molar

  // ── Section 4: MD Equilibration Phase ───────────────────────────────────
  final bool equilibrationEnabled;
  final String equilJobName;
  final String minimizationSteps; // 1000 | 5000 | 10000 | 20000 | 50000 | 100000
  final double equilTimestep; // fs  0.5 | 1 | 2 | 3 | 4
  final double equilTemperature; // K
  final double equilPressure; // bar
  final double restraintForceConstant; // kJ/mol 0–2000
  final double equilWriteTraj; // ps
  final double equilWriteLog; // ps

  // ── Section 5: MD Production Phase ──────────────────────────────────────
  final bool productionEnabled;
  final double strideDuration; // ns
  final int numberOfStrides;
  final bool compressTrajectory;
  final bool calculateRmsdOnTheFly;

  const MdSimulationEntity({
    this.proteinPdbPath = '',
    this.proteinPdbName = '',
    this.ligandPdbPath = '',
    this.ligandPdbName = '',
    this.removeWaters = true,
    this.addLigandHydrogens = false,
    this.systemTotalCharge = 0,
    this.proteinForceField = 'ff19SB',
    this.ligandForceField = 'GAFF2',
    this.waterModel = 'TIP3P',
    this.boxSizePadding = 12.0,
    this.saltType = 'NaCl',
    this.concentration = 0.15,
    this.equilibrationEnabled = true,
    this.equilJobName = 'eq_step_01_alpha',
    this.minimizationSteps = '5000',
    this.equilTimestep = 2.0,
    this.equilTemperature = 300,
    this.equilPressure = 1.013,
    this.restraintForceConstant = 700,
    this.equilWriteTraj = 10,
    this.equilWriteLog = 1,
    this.productionEnabled = true,
    this.strideDuration = 100,
    this.numberOfStrides = 1,
    this.compressTrajectory = true,
    this.calculateRmsdOnTheFly = false,
  });

  /// Total production simulation time in ns
  double get totalSimTime => strideDuration * numberOfStrides / 1000;

  /// Estimated wall-clock hours (very rough: ~1 ns/hr on GPU)
  double get estimatedHours => totalSimTime * 1.0;

  MdSimulationEntity copyWith({
    String? proteinPdbPath,
    String? proteinPdbName,
    String? ligandPdbPath,
    String? ligandPdbName,
    bool? removeWaters,
    bool? addLigandHydrogens,
    int? systemTotalCharge,
    String? proteinForceField,
    String? ligandForceField,
    String? waterModel,
    double? boxSizePadding,
    String? saltType,
    double? concentration,
    bool? equilibrationEnabled,
    String? equilJobName,
    String? minimizationSteps,
    double? equilTimestep,
    double? equilTemperature,
    double? equilPressure,
    double? restraintForceConstant,
    double? equilWriteTraj,
    double? equilWriteLog,
    bool? productionEnabled,
    double? strideDuration,
    int? numberOfStrides,
    bool? compressTrajectory,
    bool? calculateRmsdOnTheFly,
  }) {
    return MdSimulationEntity(
      proteinPdbPath: proteinPdbPath ?? this.proteinPdbPath,
      proteinPdbName: proteinPdbName ?? this.proteinPdbName,
      ligandPdbPath: ligandPdbPath ?? this.ligandPdbPath,
      ligandPdbName: ligandPdbName ?? this.ligandPdbName,
      removeWaters: removeWaters ?? this.removeWaters,
      addLigandHydrogens: addLigandHydrogens ?? this.addLigandHydrogens,
      systemTotalCharge: systemTotalCharge ?? this.systemTotalCharge,
      proteinForceField: proteinForceField ?? this.proteinForceField,
      ligandForceField: ligandForceField ?? this.ligandForceField,
      waterModel: waterModel ?? this.waterModel,
      boxSizePadding: boxSizePadding ?? this.boxSizePadding,
      saltType: saltType ?? this.saltType,
      concentration: concentration ?? this.concentration,
      equilibrationEnabled: equilibrationEnabled ?? this.equilibrationEnabled,
      equilJobName: equilJobName ?? this.equilJobName,
      minimizationSteps: minimizationSteps ?? this.minimizationSteps,
      equilTimestep: equilTimestep ?? this.equilTimestep,
      equilTemperature: equilTemperature ?? this.equilTemperature,
      equilPressure: equilPressure ?? this.equilPressure,
      restraintForceConstant:
          restraintForceConstant ?? this.restraintForceConstant,
      equilWriteTraj: equilWriteTraj ?? this.equilWriteTraj,
      equilWriteLog: equilWriteLog ?? this.equilWriteLog,
      productionEnabled: productionEnabled ?? this.productionEnabled,
      strideDuration: strideDuration ?? this.strideDuration,
      numberOfStrides: numberOfStrides ?? this.numberOfStrides,
      compressTrajectory: compressTrajectory ?? this.compressTrajectory,
      calculateRmsdOnTheFly:
          calculateRmsdOnTheFly ?? this.calculateRmsdOnTheFly,
    );
  }
}
