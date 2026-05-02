import 'package:ailixir/features/drug_repurposing/domain/enum/dr_mode.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/full/dr_full_form.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/full/dr_full_results.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_header_section.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_logger_panel.dart';
import 'package:ailixir/features/drug_repurposing/presentation/widgets/shared/dr_mode_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrFullModeView extends StatelessWidget {
  final DrugRepurposingMode currentMode;
  final ValueChanged<DrugRepurposingMode> onModeChanged;

  const DrFullModeView({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── 1. Header + mode toggle ─────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DrHeaderSection(),
                const Spacer(),
                DrModeToggle(
                  selectedMode: currentMode,
                  onModeChanged: onModeChanged,
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

        // ── 2. Form panel ───────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: const DrFullForm(),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 24.h)),

        // ── 3. Logger panel ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: const DrLoggerPanel(mode: DrugRepurposingMode.full),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 16.h)),

        // ── 4. Results ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 32.h),
            child: const DrFullResults(),
          ),
        ),
      ],
    );
  }
}
