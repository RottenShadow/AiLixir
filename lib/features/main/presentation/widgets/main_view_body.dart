import 'package:ailixir/features/similarity/presentation/views/similarity_view.dart';
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

  Widget _buildBody() {
    // Widgets are only created when this function runs for a specific index
    switch (_selectedIndex) {
      case 1:
        return const MolecularLabView();
      case 2:
        return const GenerationView();
      case 3:
        return const DockingView();
      case 4:
        return const MDView();
      case 5:
        return const HistoryView();
      case 6:
        return SimilarityView();
      default:
        return const HomeViewBody();
    }
  }

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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }
}
