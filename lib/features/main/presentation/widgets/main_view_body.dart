import 'package:ailixir/core/widgets/indexed_stack/fade_lazy_load_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/home/presentation/widgets/home_view_body.dart';
import 'package:ailixir/features/molecular_lab/presentation/views/molecular_lab_view.dart';
import 'package:ailixir/features/generation/presentation/views/generation_view.dart';
import 'package:ailixir/features/docking/presentation/views/docking_view.dart';
import 'package:ailixir/features/molecular_dynamics/presentation/views/md_view.dart';
import 'package:ailixir/features/history/presentation/views/history_view.dart';
import 'main_top_bar.dart';

// Page index constants — single source of truth
// 0 News Feed (Home View) | 1 Molecular Lab | 2 Generation | 3 Docking | 4 MD | 5 History
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
    HistoryView(), // 5
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
              // autoDisposeIndexes: [1], // auto dispose index 1 = Molecular Lab
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
