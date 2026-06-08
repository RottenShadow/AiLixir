import 'dart:convert';
import 'package:ailixir/core/entities/docking_request_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/docking/presentation/cubits/docking_cubit.dart';
import 'package:ailixir/features/docking/presentation/widgets/docking_molstar_viewer.dart';
import 'package:ailixir/features/docking/presentation/widgets/docking_log_panel.dart';
import 'package:ailixir/features/docking/presentation/widgets/docking_results_panel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _allowedExtensions = ['pdb', 'pdbqt'];

class DockingViewBody extends StatefulWidget {
  const DockingViewBody({super.key});

  @override
  State<DockingViewBody> createState() => _DockingViewBodyState();
}

class _DockingViewBodyState extends State<DockingViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _viewerKey = GlobalKey<DockingMolstarViewerState>();

  // Protein
  String? _proteinPath;
  String? _proteinName;

  // Ligand
  String? _ligandPath;
  String? _ligandName;

  // Grid box
  final _cxCtrl = TextEditingController(text: '12.451');
  final _cyCtrl = TextEditingController(text: '-8.120');
  final _czCtrl = TextEditingController(text: '24.115');
  final _sxCtrl = TextEditingController(text: '20.0');
  final _syCtrl = TextEditingController(text: '20.0');
  final _szCtrl = TextEditingController(text: '20.0');

  // Advanced
  bool _advancedOpen = false;
  final _exhaustCtrl = TextEditingController(text: '20.0');

  @override
  void initState() {
    super.initState();
    // Push the default box values to the viewer once it's ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _onBoxChanged());
  }

  @override
  void dispose() {
    _cxCtrl.dispose();
    _cyCtrl.dispose();
    _czCtrl.dispose();
    _sxCtrl.dispose();
    _syCtrl.dispose();
    _szCtrl.dispose();
    _exhaustCtrl.dispose();
    super.dispose();
  }

  // ── File picking ────────────────────────────────────────────────────────────

  Future<void> _pickProtein() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    setState(() {
      _proteinPath = file.path;
      _proteinName = file.name;
    });
    // Send raw text to viewer (mol* parses PDB/PDBQT as plain text)
    if (file.bytes != null) {
      try {
        final rawText = utf8.decode(file.bytes!);
        final fmt = file.extension?.toLowerCase() == 'pdbqt' ? 'pdbqt' : 'pdb';
        debugPrint(
          '[DockingView] Protein picked: $_proteinName, size: ${file.bytes!.length}',
        );
        _viewerKey.currentState?.loadProteinText(rawText, fmt);
      } catch (e) {
        debugPrint('[DockingView] Error decoding protein: $e');
        // Fallback to fromCharCodes if utf8 fails (e.g. if it's truly ASCII with some high-bit chars)
        final rawText = String.fromCharCodes(file.bytes!);
        _viewerKey.currentState?.loadProteinText(rawText, 'pdb');
      }
    }
  }

  Future<void> _pickLigand() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    setState(() {
      _ligandPath = file.path;
      _ligandName = file.name;
    });
    // Send raw text to viewer
    if (file.bytes != null) {
      try {
        final rawText = utf8.decode(file.bytes!);
        final extension = file.extension?.toLowerCase();
        // Use 'sdf' as default or 'mol'/'mol2' if applicable. PDB/PDBQT also work.
        final fmt = (extension == 'pdbqt' || extension == 'pdb')
            ? extension
            : 'sdf';
        debugPrint(
          '[DockingView] Ligand picked: $_ligandName, size: ${file.bytes!.length}',
        );
        _viewerKey.currentState?.loadLigandText(rawText, fmt!);
      } catch (e) {
        debugPrint('[DockingView] Error decoding ligand: $e');
        final rawText = String.fromCharCodes(file.bytes!);
        _viewerKey.currentState?.loadLigandText(rawText, 'sdf');
      }
    }
  }

  Future<void> _clearProtein() async {
    setState(() {
      _proteinPath = null;
      _proteinName = null;
    });
    _viewerKey.currentState?.clearProtein();
  }

  Future<void> _clearLigand() async {
    setState(() {
      _ligandPath = null;
      _ligandName = null;
    });
    _viewerKey.currentState?.clearLigand();
  }

  void _onBoxChanged() {
    final cx = double.tryParse(_cxCtrl.text) ?? 0;
    final cy = double.tryParse(_cyCtrl.text) ?? 0;
    final cz = double.tryParse(_czCtrl.text) ?? 0;
    final sx = double.tryParse(_sxCtrl.text) ?? 20;
    final sy = double.tryParse(_syCtrl.text) ?? 20;
    final sz = double.tryParse(_szCtrl.text) ?? 20;
    _viewerKey.currentState?.updateBox(
      cx: cx,
      cy: cy,
      cz: cz,
      sx: sx,
      sy: sy,
      sz: sz,
    );
  }

  /// Called by the viewer when JS clamps any box value.
  /// Updates all 6 fields (center + size) to reflect the clamped result.
  void _onViewerBoxCenterChanged(
    double cx,
    double cy,
    double cz, [
    double? sx,
    double? sy,
    double? sz,
  ]) {
    final newCx = cx.toStringAsFixed(3);
    final newCy = cy.toStringAsFixed(3);
    final newCz = cz.toStringAsFixed(3);
    final newSx = sx?.toStringAsFixed(3);
    final newSy = sy?.toStringAsFixed(3);
    final newSz = sz?.toStringAsFixed(3);

    // Only rebuild if something actually changed
    final centerChanged =
        _cxCtrl.text != newCx || _cyCtrl.text != newCy || _czCtrl.text != newCz;
    final sizeChanged =
        newSx != null &&
        (_sxCtrl.text != newSx ||
            _syCtrl.text != newSy ||
            _szCtrl.text != newSz);

    if (!centerChanged && !sizeChanged) return;

    setState(() {
      if (centerChanged) {
        _cxCtrl.text = newCx;
        _cyCtrl.text = newCy;
        _czCtrl.text = newCz;
        _cxCtrl.selection = TextSelection.collapsed(offset: newCx.length);
        _cyCtrl.selection = TextSelection.collapsed(offset: newCy.length);
        _czCtrl.selection = TextSelection.collapsed(offset: newCz.length);
      }
      if (sizeChanged) {
        _sxCtrl.text = newSx;
        _syCtrl.text = newSy!;
        _szCtrl.text = newSz!;
        _sxCtrl.selection = TextSelection.collapsed(offset: newSx.length);
        _syCtrl.selection = TextSelection.collapsed(offset: newSy.length);
        _szCtrl.selection = TextSelection.collapsed(offset: newSz.length);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = DockingRequestEntity(
      proteinFilePath: _proteinPath,
      proteinFileName: _proteinName,
      ligandFilePath: _ligandPath,
      ligandFileName: _ligandName,
      centerX: double.parse(_cxCtrl.text),
      centerY: double.parse(_cyCtrl.text),
      centerZ: double.parse(_czCtrl.text),
      sizeX: double.parse(_sxCtrl.text),
      sizeY: double.parse(_syCtrl.text),
      sizeZ: double.parse(_szCtrl.text),
      exhaustiveness: double.tryParse(_exhaustCtrl.text) ?? 20.0,
    );
    context.read<DockingCubit>().startDocking(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DockingCubit, DockingState>(
      builder: (context, state) {
        final isRunning = state.status == DockingStatus.polling;
        final isDone = state.status == DockingStatus.completed;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Left: Config panel ─────────────────────────────────────────
            SizedBox(
              width: 380.w,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.slate900,
                  border: Border(
                    right: BorderSide(color: AppColors.brandBorder),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.tune,
                            color: AppColors.cyan400,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Docking Configuration',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Protein file ──────────────────────────────
                            _SectionLabel('PROTEIN FILE (PDB/PDBQT)'),
                            SizedBox(height: 6.h),
                            _FileSlot(
                              fileName: _proteinName,
                              hint: 'receptor_structure.pdb',
                              enabled: !isRunning,
                              onTap: isRunning ? null : _pickProtein,
                              onClear: (!isRunning && _proteinName != null)
                                  ? _clearProtein
                                  : null,
                              validator: (_) => _proteinName == null
                                  ? 'Protein file is required'
                                  : null,
                            ),
                            SizedBox(height: 16.h),

                            // ── Ligand toggle ─────────────────────────────
                            _SectionLabel('LIGAND FILE (PDB/PDBQT)'),
                            SizedBox(height: 6.h),
                            _FileSlot(
                              fileName: _ligandName,
                              hint: 'ligand_structure.pdb',
                              enabled: !isRunning,
                              onTap: isRunning ? null : _pickLigand,
                              onClear: (!isRunning && _ligandName != null)
                                  ? _clearLigand
                                  : null,
                              validator: (_) => _ligandName == null
                                  ? 'Ligand file is required'
                                  : null,
                            ),
                            SizedBox(height: 20.h),

                            // ── Grid box ──────────────────────────────────
                            Row(
                              children: [
                                Icon(
                                  Icons.grid_4x4,
                                  color: AppColors.cyan400,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Search Space (Grid Box)',
                                  style: AppTextStyles.labelmedium.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _SectionLabel('Center Location (X, Y, Z)'),
                            SizedBox(height: 6.h),
                            _XYZRow(
                              ctrls: [_cxCtrl, _cyCtrl, _czCtrl],
                              enabled: !isRunning,
                              onChanged: (_) => _onBoxChanged(),
                            ),
                            SizedBox(height: 12.h),
                            _SectionLabel('Box Size (Å)'),
                            SizedBox(height: 6.h),
                            _XYZRow(
                              ctrls: [_sxCtrl, _syCtrl, _szCtrl],
                              enabled: !isRunning,
                              onChanged: (_) => _onBoxChanged(),
                              isSize: true,
                            ),
                            SizedBox(height: 20.h),

                            // ── Advanced ──────────────────────────────────
                            _AdvancedSection(
                              open: _advancedOpen,
                              exhaustCtrl: _exhaustCtrl,
                              enabled: !isRunning,
                              onToggle: () => setState(
                                () => _advancedOpen = !_advancedOpen,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // ── Submit / Reset ────────────────────────────
                            _ActionButton(
                              isRunning: isRunning,
                              isDone: isDone,
                              onStart: isRunning ? null : _submit,
                              onReset: isDone
                                  ? () {
                                      context.read<DockingCubit>().reset();
                                      _viewerKey.currentState?.clearAll();
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ── Log / Results ─────────────────────────────────────
                      if (state.logs.isNotEmpty ||
                          state.status == DockingStatus.polling)
                        DockingLogPanel(logs: state.logs, status: state.status),
                      if (state.status == DockingStatus.completed)
                        DockingResultsPanel(results: state.results),
                    ],
                  ),
                ),
              ),
            ),

            // ── Right: Mol* viewer ─────────────────────────────────────────
            Expanded(
              child: DockingMolstarViewer(
                key: _viewerKey,
                onBoxCenterChanged: _onViewerBoxCenterChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.labelsmall.copyWith(
        color: AppColors.slate400,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _FileSlot extends FormField<String> {
  _FileSlot({
    required String? fileName,
    required String hint,
    required bool enabled,
    required VoidCallback? onTap,
    required VoidCallback? onClear,
    super.validator,
  }) : super(
         builder: (state) {
           final hasFile = fileName != null;
           final hasError = state.hasError;
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Stack(
                 children: [
                   GestureDetector(
                     onTap: onTap,
                     child: AnimatedContainer(
                       duration: const Duration(milliseconds: 150),
                       width: double.infinity,
                       padding: EdgeInsets.symmetric(vertical: 20.h),
                       decoration: BoxDecoration(
                         color: AppColors.slate800,
                         borderRadius: BorderRadius.circular(10.r),
                         border: Border.all(
                           color: hasError
                               ? AppColors.red500
                               : hasFile
                               ? AppColors.cyan600
                               : AppColors.brandBorder,
                           width: hasFile ? 1.5 : 1,
                         ),
                       ),
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Icon(
                             hasFile
                                 ? Icons.insert_drive_file_outlined
                                 : Icons.upload_file_outlined,
                             color: hasFile
                                 ? AppColors.cyan400
                                 : AppColors.slate500,
                             size: 28.sp,
                           ),
                           SizedBox(height: 8.h),
                           Text(
                             hasFile ? fileName : hint,
                             style: AppTextStyles.bodysmall.copyWith(
                               color: hasFile
                                   ? AppColors.white
                                   : AppColors.slate500,
                             ),
                             textAlign: TextAlign.center,
                           ),
                           if (!hasFile) ...[
                             SizedBox(height: 4.h),
                             Text(
                               'Click to browse (.pdb / .pdbqt)',
                               style: AppTextStyles.bodyxs.copyWith(
                                 color: AppColors.slate600,
                               ),
                             ),
                           ],
                         ],
                       ),
                     ),
                   ),
                   // ── Clear button ────────────────────────────────────────
                   if (hasFile && onClear != null)
                     Positioned(
                       top: 6.h,
                       right: 6.w,
                       child: GestureDetector(
                         onTap: onClear,
                         child: Container(
                           width: 22.w,
                           height: 22.w,
                           decoration: BoxDecoration(
                             color: AppColors.slate700,
                             shape: BoxShape.circle,
                             border: Border.all(
                               color: AppColors.slate500,
                               width: 1,
                             ),
                           ),
                           child: Icon(
                             Icons.close,
                             size: 13.sp,
                             color: AppColors.slate300,
                           ),
                         ),
                       ),
                     ),
                 ],
               ),
               if (hasError)
                 Padding(
                   padding: EdgeInsets.only(top: 4.h, left: 4.w),
                   child: Text(
                     state.errorText!,
                     style: AppTextStyles.bodyxs.copyWith(
                       color: AppColors.red400,
                     ),
                   ),
                 ),
             ],
           );
         },
       );
}

class _XYZRow extends StatelessWidget {
  final List<TextEditingController> ctrls;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final bool isSize;

  const _XYZRow({
    required this.ctrls,
    required this.enabled,
    required this.onChanged,
    this.isSize = false,
  });

  @override
  Widget build(BuildContext context) {
    final labels = isSize ? ['W', 'H', 'D'] : ['X', 'Y', 'Z'];
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8.w : 0),
            child: TextFormField(
              controller: ctrls[i],
              enabled: enabled,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              onChanged: onChanged,
              style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
              decoration: _dockingInputDecoration(hint: labels[i]),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final val = double.tryParse(v.trim());
                if (val == null) return 'Invalid';
                if (isSize) {
                  if (val < 5) return '≥ 5';
                  if (val > 100) return '≤ 100';
                }
                return null;
              },
            ),
          ),
        );
      }),
    );
  }
}

class _AdvancedSection extends StatelessWidget {
  final bool open;
  final TextEditingController exhaustCtrl;
  final bool enabled;
  final VoidCallback onToggle;

  const _AdvancedSection({
    required this.open,
    required this.exhaustCtrl,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advanced Settings',
                style: AppTextStyles.labelmedium.copyWith(
                  color: AppColors.slate400,
                ),
              ),
              Icon(
                open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.slate400,
                size: 18.sp,
              ),
            ],
          ),
        ),
        if (open) ...[
          SizedBox(height: 12.h),
          _SectionLabel('Sampling exhaustivity:'),
          SizedBox(height: 6.h),
          TextFormField(
            controller: exhaustCtrl,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
            decoration: _dockingInputDecoration(hint: '20.0'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (double.tryParse(v.trim()) == null) return 'Invalid number';
              return null;
            },
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isRunning;
  final bool isDone;
  final VoidCallback? onStart;
  final VoidCallback? onReset;

  const _ActionButton({
    required this.isRunning,
    required this.isDone,
    required this.onStart,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    if (isDone) {
      return SizedBox(
        width: double.infinity,
        height: 44.h,
        child: ElevatedButton.icon(
          onPressed: onReset,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.slate600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          icon: Icon(Icons.refresh, color: AppColors.white, size: 16.sp),
          label: Text(
            'New Docking Job',
            style: AppTextStyles.labellarge.copyWith(color: AppColors.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: onStart,
        style: ElevatedButton.styleFrom(
          backgroundColor: isRunning ? AppColors.slate600 : AppColors.brandBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRunning) ...[
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 10.w),
            ] else ...[
              Icon(
                Icons.rocket_launch_outlined,
                color: AppColors.white,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              isRunning ? 'Running...' : 'Start Docking Job',
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

// ── Shared input decoration ────────────────────────────────────────────────────
InputDecoration _dockingInputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodymedium.copyWith(color: AppColors.slate600),
    filled: true,
    fillColor: AppColors.slate800,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
