import 'package:ailixir/core/entities/docking_entity.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/entities/md_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'see_all_state.dart';

// ─── Ligands ──────────────────────────────────────────────────────────────────

class LigandSeeAllCubit extends Cubit<SeeAllState<LigandEntity>> {
  static const _pageSize = 10;

  LigandSeeAllCubit() : super(const SeeAllState());

  // Full pool of fake data (simulates a large dataset)
  static final _pool = List.generate(
    50,
    (i) => LigandEntity(
      id: '${i + 1}',
      candidateName: 'Candidate #${(812 - i).toString().padLeft(5, '0')}',
      smiles: _smiles[i % _smiles.length],
      generatedAt: DateTime.now().subtract(Duration(hours: i * 3 + 1)),
    ),
  );

  static const _smiles = [
    'CC1=CC(=C(C=C1C)C(=O)NC2=CC=C(C=C2)C(F)(F)F)C',
    'NC1=NC2=C(N=C(N2)C(=O)N)C(=O)N1',
    'CC(C)CC1=CC=C(C=C1)C(C)C(=O)O',
    'O=C(O)c1ccccc1Nc1cccc(C(F)(F)F)c1',
    'CC(=O)Nc1ccc(O)cc1',
  ];

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: SeeAllStatus.loading,
        items: [],
        page: 0,
        hasMore: true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final items = _pool.take(_pageSize).toList();
    emit(
      state.copyWith(
        status: SeeAllStatus.loaded,
        items: items,
        page: 1,
        hasMore: items.length == _pageSize,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SeeAllStatus.loadingMore || !state.hasMore) return;
    emit(state.copyWith(status: SeeAllStatus.loadingMore));
    await Future.delayed(const Duration(milliseconds: 900));
    final start = state.page * _pageSize;
    final next = _pool.skip(start).take(_pageSize).toList();
    emit(
      state.copyWith(
        status: SeeAllStatus.loaded,
        items: [...state.items, ...next],
        page: state.page + 1,
        hasMore: next.length == _pageSize,
      ),
    );
  }
}

// ─── Docking ──────────────────────────────────────────────────────────────────

class DockingSeeAllCubit extends Cubit<SeeAllState<DockingEntity>> {
  static const _pageSize = 10;

  DockingSeeAllCubit() : super(const SeeAllState());

  static final _targets = [
    ('6LU7', 'SARS-CoV-2 Mpro', -10.4),
    ('1AKI', 'Lysozyme', -9.8),
    ('3N75', 'BACE1', -8.5),
    ('4HHB', 'Hemoglobin', -7.9),
    ('2HHB', 'Deoxyhemoglobin', -8.1),
    ('1HSG', 'HIV Protease', -11.2),
    ('3PTB', 'Trypsin', -7.3),
    ('1ATP', 'cAMP-dependent PK', -9.1),
  ];

  static final _pool = List.generate(40, (i) {
    final t = _targets[i % _targets.length];
    return DockingEntity(
      id: '${i + 1}',
      targetId: t.$1,
      targetName: t.$2,
      jobId: 'JOB-${1000 + i}-${44000 + i * 7}',
      createdAt: DateTime.now().subtract(Duration(days: i + 1)),
      vinaScore: t.$3 - (i % 3) * 0.3,
    );
  });

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: SeeAllStatus.loading,
        items: [],
        page: 0,
        hasMore: true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final items = _pool.take(_pageSize).toList();
    emit(
      state.copyWith(
        status: SeeAllStatus.loaded,
        items: items,
        page: 1,
        hasMore: items.length == _pageSize,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SeeAllStatus.loadingMore || !state.hasMore) return;
    emit(state.copyWith(status: SeeAllStatus.loadingMore));
    await Future.delayed(const Duration(milliseconds: 900));
    final start = state.page * _pageSize;
    final next = _pool.skip(start).take(_pageSize).toList();
    emit(
      state.copyWith(
        status: SeeAllStatus.loaded,
        items: [...state.items, ...next],
        page: state.page + 1,
        hasMore: next.length == _pageSize,
      ),
    );
  }
}

// ─── MD ───────────────────────────────────────────────────────────────────────

class MdSeeAllCubit extends Cubit<SeeAllState<MdEntity>> {
  static const _pageSize = 10;

  MdSeeAllCubit() : super(const SeeAllState());

  static final _tasks = [
    ('ACE2_spike_interaction', 'AMBER1\n4SB', '100 ns', MdStatus.completed),
    ('B-DNA_solvated_box', 'CHARMM\n36m', '50 ns', MdStatus.completed),
    ('Protein_folding_run', 'GROMOS\n54A7', '200 ns', MdStatus.running),
    ('Membrane_bilayer_sim', 'OPLS-AA', '75 ns', MdStatus.completed),
    ('Ligand_binding_free_energy', 'AMBER\nff14SB', '500 ns', MdStatus.failed),
    ('RNA_duplex_dynamics', 'CHARMM\n36', '150 ns', MdStatus.completed),
  ];

  static final _pool = List.generate(36, (i) {
    final t = _tasks[i % _tasks.length];
    return MdEntity(
      id: '${i + 1}',
      simulationTask: '${t.$1}_${i + 1}',
      createdAt: DateTime(2023, 10, 24).subtract(Duration(days: i)),
      forcefield: t.$2,
      duration: t.$3,
      status: t.$4,
    );
  });

  Future<void> loadFirstPage() async {
    emit(
      state.copyWith(
        status: SeeAllStatus.loading,
        items: [],
        page: 0,
        hasMore: true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final items = _pool.take(_pageSize).toList();
    emit(
      state.copyWith(
        status: SeeAllStatus.loaded,
        items: items,
        page: 1,
        hasMore: items.length == _pageSize,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (state.status == SeeAllStatus.loadingMore || !state.hasMore) return;
    emit(state.copyWith(status: SeeAllStatus.loadingMore));
    await Future.delayed(const Duration(milliseconds: 900));
    final start = state.page * _pageSize;
    final next = _pool.skip(start).take(_pageSize).toList();
    emit(
      state.copyWith(
        status: SeeAllStatus.loaded,
        items: [...state.items, ...next],
        page: state.page + 1,
        hasMore: next.length == _pageSize,
      ),
    );
  }
}
