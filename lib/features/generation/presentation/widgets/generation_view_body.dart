import 'package:ailixir/core/entities/generation_request_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/generation/presentation/cubits/generation_cubit.dart';
import 'package:ailixir/features/generation/presentation/widgets/generation_log_panel.dart';
import 'package:ailixir/features/generation/presentation/widgets/generation_results_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// // Available proteins for the dropdown
// const _proteins = [
//   '1AKI - Lysozyme',
//   '6LU7 - SARS-CoV-2 Mpro',
//   '3N75 - BACE1',
//   '1HSG - HIV Protease',
//   '4HHB - Hemoglobin',
// ];

class GenerationViewBody extends StatefulWidget {
  const GenerationViewBody({super.key});

  @override
  State<GenerationViewBody> createState() => _GenerationViewBodyState();
}

class _GenerationViewBodyState extends State<GenerationViewBody> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProtein;
  final _numMoleculesCtrl = TextEditingController(text: '100');
  final _returnTopKCtrl = TextEditingController(text: '10');
  String _dockingMode = 'off';
  final _dockTopKCtrl = TextEditingController(text: '5');

  @override
  void dispose() {
    _numMoleculesCtrl.dispose();
    _returnTopKCtrl.dispose();
    _dockTopKCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = GenerationRequestEntity(
      targetProtein: _selectedProtein!,
      numMolecules: int.parse(_numMoleculesCtrl.text.trim()),
      returnTopK: int.parse(_returnTopKCtrl.text.trim()),
      dockingMode: _dockingMode,
      dockTopK: _dockingMode == 'top_k'
          ? int.tryParse(_dockTopKCtrl.text.trim())
          : null,
    );
    context.read<GenerationCubit>().startGeneration(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerationCubit, GenerationState>(
      builder: (context, state) {
        final isRunning = state.status == GenerationStatus.polling;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.tune, color: AppColors.cyan400, size: 22.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'Generation Configuration',
                    style: AppTextStyles.h2.copyWith(color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // ── Form ────────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Target Protein | Number of Molecules
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _TargetProteinField(
                            value: _selectedProtein,
                            onChanged: (v) =>
                                setState(() => _selectedProtein = v),
                            enabled: !isRunning,
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: _NumMoleculesField(
                            controller: _numMoleculesCtrl,
                            enabled: !isRunning,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Row 2: Return Top K | (empty for spacing)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ReturnTopKField(
                            controller: _returnTopKCtrl,
                            enabled: !isRunning,
                          ),
                        ),
                        SizedBox(width: 24.w),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Row 3: Docking Mode (full width, expandable)
                    _DockingModeSection(
                      dockingMode: _dockingMode,
                      dockTopKCtrl: _dockTopKCtrl,
                      returnTopKCtrl: _returnTopKCtrl,
                      enabled: !isRunning,
                      onModeChanged: (mode) =>
                          setState(() => _dockingMode = mode),
                    ),
                    SizedBox(height: 20.h),

                    // Start Button
                    _StartButton(
                      isRunning: isRunning,
                      onPressed: isRunning ? null : _submit,
                      onReset: state.status == GenerationStatus.completed
                          ? () => context.read<GenerationCubit>().reset()
                          : null,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // ── Log Panel ─────────────────────────────────────────────────
              if (state.logs.isNotEmpty ||
                  state.status == GenerationStatus.polling)
                GenerationLogPanel(logs: state.logs, status: state.status),

              // ── Results Panel (completed) ────────────────────────────────
              if (state.status == GenerationStatus.completed)
                GenerationResultsPanel(
                  ligands: state.results,
                  files: state.files,
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Form Fields ──────────────────────────────────────────────────────────────

class _TargetProteinField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const _TargetProteinField({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  static const _proteinValue = '4WKQ - EGFR kinase + Gefitinib';
  static const _disabledLabel = 'Other options will come soon!';

  @override
  Widget build(BuildContext context) {
    final selected = value == _proteinValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Target Protein Selection'),
        SizedBox(height: 6.h),
        ExpansionTile(
          initiallyExpanded: value != null,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: AppColors.brandBorder),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: AppColors.brandBorder),
          ),
          collapsedBackgroundColor: AppColors.slate800,
          backgroundColor: AppColors.slate800,
          title: Row(
            children: [
              SizedBox(width: 8.w),
              Icon(Icons.format_shapes, size: 16.sp, color: AppColors.cyan400),
              SizedBox(width: 8.w),
              if (value == null)
                Text(
                  'Select a Target Protein',
                  style: AppTextStyles.labelmedium.copyWith(
                    color: AppColors.slate300,
                  ),
                ),
              if (value != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.slate700,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    value!,
                    style: AppTextStyles.labelmedium.copyWith(
                      color: AppColors.slate300,
                    ),
                  ),
                ),
              ],
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioGroup<String>(
                    groupValue: value,
                    onChanged: (v) {
                      if (enabled && v != null) onChanged(v);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: enabled
                              ? () => onChanged(_proteinValue)
                              : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 4.w,
                            ),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: _proteinValue,
                                  activeColor: AppColors.cyan400,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  _proteinValue,
                                  style: AppTextStyles.bodymedium.copyWith(
                                    color: selected
                                        ? AppColors.white
                                        : AppColors.slate400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 4.w,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.radio_button_off,
                          size: 16.sp,
                          color: AppColors.slate600,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          _disabledLabel,
                          style: AppTextStyles.bodymedium.copyWith(
                            color: AppColors.slate600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NumMoleculesField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _NumMoleculesField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Number of Molecules'),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: _inputDecoration(hint: '100'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            final n = int.tryParse(v.trim());
            if (n == null || n < 10) return 'Min: 10';
            if (n > 10000) return 'Max: 10,000';
            return null;
          },
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: 10',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
            ),
            Text(
              'Max: 10,000',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReturnTopKField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _ReturnTopKField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Return Top K'),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: _inputDecoration(hint: '10'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            final n = int.tryParse(v.trim());
            if (n == null || n < 1) return 'Min: 1';
            if (n > 10) return 'Max: 10';
            return null;
          },
        ),
        SizedBox(height: 4.h),
        Text(
          'Min: 1, Max: 10',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _DockingModeSection extends StatelessWidget {
  final String dockingMode;
  final TextEditingController dockTopKCtrl;
  final TextEditingController returnTopKCtrl;
  final bool enabled;
  final ValueChanged<String> onModeChanged;

  const _DockingModeSection({
    required this.dockingMode,
    required this.dockTopKCtrl,
    required this.returnTopKCtrl,
    required this.enabled,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: dockingMode == 'top_k',
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(color: AppColors.brandBorder),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(color: AppColors.brandBorder),
      ),
      collapsedBackgroundColor: AppColors.slate800,
      backgroundColor: AppColors.slate800,
      title: Row(
        children: [
          SizedBox(width: 8.w),
          Icon(Icons.tune, size: 16.sp, color: AppColors.cyan400),
          SizedBox(width: 8.w),
          Text(
            'Docking Mode',
            style: AppTextStyles.labelmedium.copyWith(
              color: AppColors.slate300,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.slate700,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              dockingMode.toUpperCase(),
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.cyan400),
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioGroup<String>(
                groupValue: dockingMode,
                onChanged: (v) {
                  if (enabled && v != null) onModeChanged(v);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ['off', 'all', 'top_k'].map((mode) {
                    final selected = dockingMode == mode;
                    return InkWell(
                      onTap: enabled ? () => onModeChanged(mode) : null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 4.w,
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: mode,
                              activeColor: AppColors.cyan400,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              mode == 'off'
                                  ? 'Off'
                                  : mode == 'all'
                                  ? 'All'
                                  : 'Top K',
                              style: AppTextStyles.bodymedium.copyWith(
                                color: selected
                                    ? AppColors.white
                                    : AppColors.slate400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (dockingMode == 'top_k') ...[
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: _DockTopKField(
                    controller: dockTopKCtrl,
                    returnTopKCtrl: returnTopKCtrl,
                    enabled: enabled,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DockTopKField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController returnTopKCtrl;
  final bool enabled;
  const _DockTopKField({
    required this.controller,
    required this.returnTopKCtrl,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Dock Top K'),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: _inputDecoration(hint: '5'),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            final n = int.tryParse(v.trim());
            if (n == null || n < 1) return 'Min: 1';
            final returnVal = int.tryParse(returnTopKCtrl.text.trim());
            if (returnVal != null && n > returnVal) {
              return 'Must be ≤ Return Top K';
            }
            return null;
          },
        ),
        SizedBox(height: 4.h),
        Text(
          'Number of top molecules to dock.',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _StartButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback? onPressed;
  final VoidCallback? onReset;

  const _StartButton({
    required this.isRunning,
    required this.onPressed,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    if (onReset != null) {
      return Row(
        children: [
          Expanded(
            child: _buildBtn(
              label: 'New Generation',
              icon: Icons.refresh,
              color: AppColors.slate600,
              onPressed: onReset,
            ),
          ),
        ],
      );
    }

    return _buildBtn(
      label: isRunning ? 'Running...' : 'Start Generation Job',
      icon: isRunning ? null : Icons.rocket_launch_outlined,
      color: isRunning ? AppColors.slate600 : AppColors.brandBlue,
      onPressed: onPressed,
      isLoading: isRunning,
    );
  }

  Widget _buildBtn({
    required String label,
    IconData? icon,
    required Color color,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 10.w),
            ] else if (icon != null) ...[
              Icon(icon, color: AppColors.white, size: 16.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: AppTextStyles.labellarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.labelmedium.copyWith(color: AppColors.slate300),
    );
  }
}

InputDecoration _inputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodymedium.copyWith(color: AppColors.slate600),
    filled: true,
    fillColor: AppColors.slate800,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
      borderSide: BorderSide(color: AppColors.cyan600),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.red500),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.red500),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: AppColors.brandBorder),
    ),
  );
}
