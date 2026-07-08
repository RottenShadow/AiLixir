import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import '../cubits/molecular_lab_cubit.dart';
import '../widgets/molstar_web_viewer.dart';

class MolecularLabView extends StatelessWidget {
  const MolecularLabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MolecularLabCubit(),
      child: const MolecularLabViewBody(),
    );
  }
}

class MolecularLabViewBody extends StatefulWidget {
  const MolecularLabViewBody({super.key});

  @override
  State<MolecularLabViewBody> createState() => _MolecularLabViewBodyState();
}

class _MolecularLabViewBodyState extends State<MolecularLabViewBody> {
  final TextEditingController _pdbCtrl = TextEditingController();

  // Quick-access sample structures
  static const _samples = [
    _Sample('4WKQ', 'EGFR kinase + Gefitinib', Icons.coronavirus),
    _Sample('4HHB', 'Haemoglobin', Icons.water_drop),
    _Sample('1CRN', 'Crambin', Icons.grain),
    _Sample('7BV2', 'SARS-CoV-2 Spike', Icons.coronavirus),
    _Sample('6VXX', 'COVID-19 S protein', Icons.biotech),
  ];

  @override
  void dispose() {
    _pdbCtrl.dispose();
    super.dispose();
  }

  void _load(String pdb) {
    context.read<MolecularLabCubit>().loadPdb(pdb);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000,
      child: Column(
        children: [
          // ── Top toolbar ──────────────────────────────────────────────────
          BlocBuilder<MolecularLabCubit, MolecularLabState>(
            builder: (context, state) {
              String? activePdb;
              if (state is MolecularLabLoaded) activePdb = state.pdbId;

              return _Toolbar(
                pdbCtrl: _pdbCtrl,
                samples: _samples,
                activePdbId: activePdb,
                onLoad: _load,
              );
            },
          ),

          // ── Viewer area ──────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<MolecularLabCubit, MolecularLabState>(
              buildWhen: (previous, current) =>
                  (previous is MolecularLabInitial &&
                      current is MolecularLabLoaded) ||
                  (previous is MolecularLabLoaded &&
                      current is MolecularLabInitial),
              builder: (context, state) {
                return Stack(
                  children: [
                    // The WebView viewer - initialized ONLY ONCE.
                    // We don't use ValueKey here so it preserves state.
                    const MolstarWebViewer(),

                    // Empty state overlay (shown if no structure is loaded)
                    if (state is MolecularLabInitial)
                      _EmptyState(samples: _samples, onTap: _load),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toolbar
// ─────────────────────────────────────────────────────────────────────────────

class _Toolbar extends StatelessWidget {
  final TextEditingController pdbCtrl;
  final List<_Sample> samples;
  final String? activePdbId;
  final ValueChanged<String> onLoad;

  const _Toolbar({
    required this.pdbCtrl,
    required this.samples,
    required this.activePdbId,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.brandBorder)),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, color: AppColors.brandBlue, size: 20.sp),
          SizedBox(width: 10.w),
          Text('Mol Lab', style: AppTextStyles.h4),
          SizedBox(width: 32.w),

          ...samples.map(
            (s) => Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: _SampleChip(
                sample: s,
                active: activePdbId == s.pdbId,
                onTap: () => onLoad(s.pdbId),
              ),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: 180.w,
            height: 36.h,
            child: TextField(
              controller: pdbCtrl,
              style: AppTextStyles.bodysmall.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'PDB ID (e.g. 4WKQ)',
                hintStyle: AppTextStyles.bodysmall.copyWith(
                  color: AppColors.authTextSecondary,
                ),
                filled: true,
                fillColor: AppColors.slate900,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.brandBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.brandBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppColors.brandBlue,
                    width: 1.5,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 16.sp,
                    color: AppColors.authTextSecondary,
                  ),
                  onPressed: () => onLoad(pdbCtrl.text),
                ),
              ),
              onSubmitted: onLoad,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick-access sample chip
// ─────────────────────────────────────────────────────────────────────────────

class _SampleChip extends StatelessWidget {
  final _Sample sample;
  final bool active;
  final VoidCallback onTap;

  const _SampleChip({
    required this.sample,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: active
              ? AppColors.brandBlue.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: active
                ? AppColors.brandBlue.withValues(alpha: 0.5)
                : AppColors.brandBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              sample.icon,
              size: 12.sp,
              color: active ? AppColors.brandBlue : AppColors.authTextSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              sample.pdbId,
              style: AppTextStyles.caption.copyWith(
                color: active
                    ? AppColors.brandBlue
                    : AppColors.authTextSecondary,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state (shown before any structure is loaded)
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final List<_Sample> samples;
  final ValueChanged<String> onTap;

  const _EmptyState({required this.samples, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate1000, // Solid background to cover the viewer
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.biotech_outlined,
              size: 72.sp,
              color: AppColors.brandBlue.withValues(alpha: 0.2),
            ),
            SizedBox(height: 24.h),
            Text('Mol Lab', style: AppTextStyles.h2),
            SizedBox(height: 8.h),
            Text(
              'Enter a PDB ID in the toolbar or pick a sample structure below.',
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.authTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 10.h,
              alignment: WrapAlignment.center,
              children: samples
                  .map(
                    (s) => _EmptySampleCard(
                      sample: s,
                      onTap: () => onTap(s.pdbId),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySampleCard extends StatefulWidget {
  final _Sample sample;
  final VoidCallback onTap;

  const _EmptySampleCard({required this.sample, required this.onTap});

  @override
  State<_EmptySampleCard> createState() => _EmptySampleCardState();
}

class _EmptySampleCardState extends State<_EmptySampleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 150.w,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.brandBlue.withValues(alpha: 0.08)
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _hovered
                  ? AppColors.brandBlue.withValues(alpha: 0.4)
                  : AppColors.brandBorder,
            ),
          ),
          child: Column(
            children: [
              Icon(widget.sample.icon, size: 28.sp, color: AppColors.brandBlue),
              SizedBox(height: 10.h),
              Text(
                widget.sample.pdbId,
                style: AppTextStyles.labelsmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.sample.name,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.authTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sample {
  final String pdbId;
  final String name;
  final IconData icon;

  const _Sample(this.pdbId, this.name, this.icon);
}
