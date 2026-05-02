import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/full/dr_full_cubit.dart';
import 'package:ailixir/features/drug_repurposing/presentation/cubits/quick/dr_quick_cubit.dart';
import 'package:ailixir/features/drug_repurposing/domain/enum/dr_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Terminal-style logger panel — shows logs for the specified mode.
class DrLoggerPanel extends StatefulWidget {
  final DrugRepurposingMode mode;
  const DrLoggerPanel({super.key, required this.mode});

  @override
  State<DrLoggerPanel> createState() => _DrLoggerPanelState();
}

class _DrLoggerPanelState extends State<DrLoggerPanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == DrugRepurposingMode.quick) {
      return BlocConsumer<DrQuickCubit, DrQuickState>(
        listener: (_, __) => _scrollToBottom(),
        builder: (context, state) {
          return _TerminalContainer(
            mode: widget.mode,
            scrollController: _scrollController,
            logs: state.logs,
            isLoading: state is DrQuickLoading,
            isError: state is DrQuickError,
            isSuccess: state is DrQuickSuccess,
            onReset: () => context.read<DrQuickCubit>().clearLogs(),
          );
        },
      );
    } else {
      return BlocConsumer<DrFullCubit, DrFullState>(
        listener: (_, __) => _scrollToBottom(),
        builder: (context, state) {
          return _TerminalContainer(
            mode: widget.mode,
            scrollController: _scrollController,
            logs: state.logs,
            isLoading: state is DrFullLoading,
            isError: state is DrFullError,
            isSuccess: state is DrFullSuccess,
            onReset: () => context.read<DrFullCubit>().clearLogs(),
          );
        },
      );
    }
  }
}

class _TerminalContainer extends StatelessWidget {
  final DrugRepurposingMode mode;
  final List<String> logs;
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final VoidCallback onReset;
  final ScrollController? scrollController;

  const _TerminalContainer({
    required this.mode,
    required this.logs,
    required this.isLoading,
    required this.isError,
    required this.isSuccess,
    required this.onReset,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFF080E1C),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        children: [
          _TerminalHeader(
            mode: mode,
            isLoading: isLoading,
            isError: isError,
            isSuccess: isSuccess,
            logs: logs,
            onReset: onReset,
          ),
          Expanded(
            child: SelectionArea(
              child: logs.isNotEmpty
                  ? _TerminalLogs(logs: logs)
                  : _EmptyTerminal(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Terminal Logs ───────────────────────────────────────────────────────────

class _TerminalLogs extends StatelessWidget {
  const _TerminalLogs({required this.logs});

  final List<String> logs;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: SelectableText.rich(
          TextSpan(
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11.sp,
              height: 1.5,
            ),
            children: logs.map((log) {
              final isError = log.contains('✗');
              final isSuccess = log.contains('✓');
              final color = isError
                  ? AppColors.red400
                  : isSuccess
                  ? const Color(0xFF10B981)
                  : AppColors.slate400;
              final prefix = isError
                  ? '✗'
                  : isSuccess
                  ? '✓'
                  : '›';

              return TextSpan(
                children: [
                  TextSpan(
                    text: '$prefix ',
                    style: TextStyle(color: color, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '${log.replaceAll('✓ ', '').replaceAll('✗ ', '')}\n',
                    style: TextStyle(color: color.withOpacity(0.85)),
                  ),
                ],
              );
            }).toList(),
          ),
          scrollPhysics: const ClampingScrollPhysics(),
        ),
      ),
    );
  }
}

// ── Terminal header ───────────────────────────────────────────────────────────

class _TerminalHeader extends StatelessWidget {
  final DrugRepurposingMode mode;
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final List<String> logs;
  final VoidCallback onReset;

  const _TerminalHeader({
    required this.mode,
    required this.isLoading,
    required this.isError,
    required this.isSuccess,
    required this.logs,
    required this.onReset,
  });

  void _copyLogs(BuildContext context) {
    if (logs.isEmpty) return;
    final text = logs.join('\n');
    Clipboard.setData(ClipboardData(text: text));
    AppToast.showSuccessToast(
      context: context,
      message: 'Logs copied to clipboard!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = isError
        ? AppColors.red400
        : isSuccess
        ? const Color(0xFF10B981)
        : isLoading
        ? const Color(0xFF22D3EE)
        : AppColors.slate500;

    final statusLabel = isError
        ? 'ERROR'
        : isSuccess
        ? 'COMPLETE'
        : isLoading
        ? 'RUNNING'
        : 'IDLE';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        border: const Border(bottom: BorderSide(color: AppColors.brandBorder)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 14.w,
            height: 14.w,
            child: IconButton(
              icon: const Icon(Icons.clear),
              iconSize: 10.sp,
              onPressed: onReset,
              color: AppColors.white,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: const CircleBorder(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.terminal, size: 16.sp, color: AppColors.slate500),
          SizedBox(width: 8.w),
          Text(
            'ailixir-dr-${mode.name} ~ console',
            style: AppTextStyles.caption.copyWith(color: AppColors.slate400),
          ),
          const Spacer(),
          if (logs.isNotEmpty) ...[
            IconButton(
              icon: Icon(
                Icons.copy_rounded,
                size: 14.sp,
                color: AppColors.slate500,
              ),
              onPressed: () => _copyLogs(context),
              tooltip: 'Copy Logs',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: 12.w),
          ],
          if (isLoading)
            SizedBox(
              width: 10.w,
              height: 10.h,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: statusColor,
              ),
            ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: statusColor.withOpacity(0.4)),
            ),
            child: Text(
              statusLabel,
              style: AppTextStyles.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyTerminal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.terminal, size: 32.sp, color: AppColors.slate700),
          SizedBox(height: 10.h),
          Text(
            'Awaiting input...',
            style: AppTextStyles.bodysmall.copyWith(color: AppColors.slate600),
          ),
          SizedBox(height: 4.h),
          Text(
            'Select a mode and run a query to see logs here.',
            style: AppTextStyles.caption.copyWith(color: AppColors.slate700),
          ),
        ],
      ),
    );
  }
}
