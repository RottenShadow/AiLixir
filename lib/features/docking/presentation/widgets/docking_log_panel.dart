import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DockingLogPanel extends StatefulWidget {
  final List<String> logs;
  const DockingLogPanel({super.key, required this.logs});

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
            _PulsingDot(),
            SizedBox(width: 8.w),
            Text('Status Log',
                style: AppTextStyles.h5.copyWith(color: AppColors.white)),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.blue900.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text('POLLING',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.blue400,
                    fontWeight: FontWeight.w700,
                  )),
            ),
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
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  log,
                  style: AppTextStyles.bodyxs.copyWith(
                    color: log.contains('Completed')
                        ? AppColors.emerald400
                        : log.contains('progress')
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
        Text('Polling every 15 seconds...',
            style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate600)),
      ],
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
