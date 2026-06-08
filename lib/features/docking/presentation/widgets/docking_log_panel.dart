import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/docking/presentation/cubits/docking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DockingLogPanel extends StatefulWidget {
  final List<String> logs;
  final DockingStatus status;
  const DockingLogPanel({super.key, required this.logs, required this.status});

  @override
  State<DockingLogPanel> createState() => _DockingLogPanelState();
}

class _DockingLogPanelState extends State<DockingLogPanel> {
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(DockingLogPanel old) {
    super.didUpdateWidget(old);
    if (widget.logs.length != old.logs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  bool get _hasError =>
      widget.status == DockingStatus.idle &&
      widget.logs.any(
        (l) =>
            l.contains('Failed') || l.contains('failed') || l.contains('Error'),
      );

  String get _statusHint {
    if (widget.status == DockingStatus.polling)
      return 'Polling every 15 seconds...';
    if (_hasError) return 'Job finished with errors. Review logs above.';
    if (widget.status == DockingStatus.completed)
      return 'Docking completed successfully.';
    return '';
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.status == DockingStatus.polling)
              _PulsingDot()
            else if (_hasError)
              _StatusIcon(icon: Icons.error, color: AppColors.red400)
            else
              _StatusIcon(
                icon: Icons.check_circle,
                color: AppColors.emerald400,
              ),
            SizedBox(width: 8.w),
            Text(
              'Status Log',
              style: AppTextStyles.h5.copyWith(color: AppColors.white),
            ),
            SizedBox(width: 8.w),
            _StatusBadge(status: widget.status, hasError: _hasError),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          height: 140.h,
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.slate900,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.brandBorder),
          ),
          child: ListView.builder(
            controller: _scroll,
            itemCount: widget.logs.length,
            itemBuilder: (_, i) {
              final log = widget.logs[i];
              final isError =
                  log.contains('Failed') ||
                  log.contains('failed') ||
                  log.contains('Error');
              final isCompleted = log.contains('Completed');
              final isProgress =
                  log.contains('progress') || log.contains('Polling');
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  log,
                  style: AppTextStyles.bodyxs.copyWith(
                    color: isError
                        ? AppColors.red400
                        : isCompleted
                        ? AppColors.emerald400
                        : isProgress
                        ? AppColors.cyan300
                        : AppColors.slate400,
                    fontFamily: 'monospace',
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _statusHint,
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate600),
        ),
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _StatusIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: 16.sp);
  }
}

class _StatusBadge extends StatelessWidget {
  final DockingStatus status;
  final bool hasError;
  const _StatusBadge({required this.status, required this.hasError});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = hasError
        ? (AppColors.red900.withValues(alpha: 0.5), AppColors.red400, 'ERROR')
        : status == DockingStatus.polling
        ? (
            AppColors.blue900.withValues(alpha: 0.5),
            AppColors.blue400,
            'POLLING',
          )
        : status == DockingStatus.completed
        ? (
            AppColors.emerald900.withValues(alpha: 0.5),
            AppColors.emerald400,
            'COMPLETED',
          )
        : (AppColors.slate800, AppColors.slate400, 'IDLE');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelsmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0).animate(_ctrl),
      child: Container(
        width: 7.w,
        height: 7.w,
        decoration: const BoxDecoration(
          color: AppColors.cyan400,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
