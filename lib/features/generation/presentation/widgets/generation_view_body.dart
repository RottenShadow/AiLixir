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

// Available proteins for the dropdown
const _proteins = [
  '1AKI - Lysozyme',
  '6LU7 - SARS-CoV-2 Mpro',
  '3N75 - BACE1',
  '1HSG - HIV Protease',
  '4HHB - Hemoglobin',
];

class GenerationViewBody extends StatefulWidget {
  const GenerationViewBody({super.key});

  @override
  State<GenerationViewBody> createState() => _GenerationViewBodyState();
}

class _GenerationViewBodyState extends State<GenerationViewBody> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProtein;
  final _numGenCtrl = TextEditingController(text: '100');
  final _smilesCtrl = TextEditingController();
  final _seedCtrl = TextEditingController();

  @override
  void dispose() {
    _numGenCtrl.dispose();
    _smilesCtrl.dispose();
    _seedCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = GenerationRequestEntity(
      targetProtein: _selectedProtein!,
      numGenerations: int.parse(_numGenCtrl.text.trim()),
      smilesSeed: _smilesCtrl.text.trim().isEmpty
          ? null
          : _smilesCtrl.text.trim(),
      randomSeed: _seedCtrl.text.trim().isEmpty
          ? null
          : int.tryParse(_seedCtrl.text.trim()),
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
                    // Row 1: Target Protein | Number of Generations
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
                          child: _NumGenerationsField(
                            controller: _numGenCtrl,
                            enabled: !isRunning,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Row 2: SMILES Seed | Random Seed + Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _SmilesSeedField(
                            controller: _smilesCtrl,
                            enabled: !isRunning,
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _RandomSeedField(
                                controller: _seedCtrl,
                                enabled: !isRunning,
                              ),
                              SizedBox(height: 20.h),
                              _StartButton(
                                isRunning: isRunning,
                                onPressed: isRunning ? null : _submit,
                                onReset:
                                    state.status == GenerationStatus.completed
                                    ? () => context
                                          .read<GenerationCubit>()
                                          .reset()
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // ── Log Panel (polling) ──────────────────────────────────────
              if (state.status == GenerationStatus.polling)
                GenerationLogPanel(logs: state.logs),

              // ── Results Panel (completed) ────────────────────────────────
              if (state.status == GenerationStatus.completed)
                GenerationResultsPanel(ligands: state.results),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Target Protein Selection'),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: AppColors.slate800,
          style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: _inputDecoration(hint: 'Select a protein target'),
          items: _proteins
              .map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(
                    p,
                    style: AppTextStyles.bodymedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          validator: (v) => v == null ? 'Please select a target protein' : null,
        ),
        SizedBox(height: 6.h),
        Text(
          'Note: More proteins will be added soon.',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _NumGenerationsField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _NumGenerationsField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Number of Generations'),
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
            if (n == null || n < 1) return 'Min: 1';
            if (n > 10000) return 'Max: 10,000';
            return null;
          },
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: 1',
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

class _SmilesSeedField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _SmilesSeedField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('SMILES Seed Input'),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: 5,
          style: AppTextStyles.bodymedium.copyWith(
            color: AppColors.white,
            fontFamily: 'monospace',
          ),
          decoration: _inputDecoration(
            hint: 'Enter SMILES string (e.g.,\nCC1=CC(=C(C=C1)C(=O)...',
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Provide a starting chemical structure for directed generation.',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _RandomSeedField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _RandomSeedField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _FieldLabel('Random Seed'),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.slate700,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Optional',
                style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: _inputDecoration(hint: 'e.g., 42'),
        ),
        SizedBox(height: 6.h),
        Text(
          'Fixed seed for reproducible generation results.',
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
