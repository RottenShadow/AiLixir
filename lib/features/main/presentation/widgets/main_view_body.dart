import 'package:ailixir/core/widgets/indexed_stack/fade_lazy_load_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/home/presentation/widgets/home_view_body.dart';
import 'package:ailixir/features/molecular_lab/presentation/views/molecular_lab_view.dart';
import 'package:ailixir/features/generation/presentation/views/generation_view.dart';
import 'package:ailixir/features/docking/presentation/views/docking_view.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/views/md_view.dart';
import 'package:ailixir/features/drug_repurposing/presentation/views/drug_repurposing_view.dart';
import 'package:ailixir/features/chemical_search/presentation/views/chemical_search_view.dart';
import 'package:ailixir/features/admet/presentation/views/admet_view.dart';
import 'package:ailixir/features/history/presentation/views/history_view.dart';
import 'main_top_bar.dart';

// Page index constants — single source of truth
class MainViewBody extends StatefulWidget {
  const MainViewBody({super.key});

  @override
  State<MainViewBody> createState() => _MainViewBodyState();
}

class _MainViewBodyState extends State<MainViewBody> {
  int _selectedIndex = 0;

  // All screens are kept alive in the IndexedStack — built once, never rebuilt.
  static const _screens = [
    HomeViewBody(), // 0
    MolecularLabView(), // 1
    GenerationView(), // 2
    DockingView(), // 3
    MDView(), // 4
    DrugRepurposingView(), // 5
    ChemicalSearchView(), // 6
    AdmetView(), // 7
    HistoryView(), // 8
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000,
      child: Column(
        children: [
          MainTopBar(
            selectedIndex: _selectedIndex,
            onNavTap: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(
            child: FadeLazyLoadIndexedStack(
              index: _selectedIndex,
              // autoDisposeIndexes: [1], // auto dispose index 1 = Mol Lab
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
