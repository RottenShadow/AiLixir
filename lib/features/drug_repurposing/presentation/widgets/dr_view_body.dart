import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/drug_repurposing/domain/enum/dr_mode.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/full/dr_full_view.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/quick/dr_quick_view.dart';
import 'package:flutter/material.dart';

/// Root body for the Drug Repurposing screen.
///
/// Separates Quick and Full modes into distinct sub-views handled via [IndexedStack].
/// Each sub-view contains its own header, form, logger, and results.
class DrViewBody extends StatefulWidget {
  const DrViewBody({super.key});

  @override
  State<DrViewBody> createState() => _DrViewBodyState();
}

class _DrViewBodyState extends State<DrViewBody>
    with SingleTickerProviderStateMixin {
  DrugRepurposingMode _mode = DrugRepurposingMode.quick;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  // 0 = quick, 1 = full
  int get _modeIndex => _mode == DrugRepurposingMode.quick ? 0 : 1;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onModeChanged(DrugRepurposingMode mode) {
    if (mode == _mode) return;
    _animController.reverse().then((_) {
      setState(() => _mode = mode);
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: IndexedStack(
          index: _modeIndex,
          children: [
            DrQuickModeView(currentMode: _mode, onModeChanged: _onModeChanged),
            DrFullModeView(currentMode: _mode, onModeChanged: _onModeChanged),
          ],
        ),
      ),
    );
  }
}
