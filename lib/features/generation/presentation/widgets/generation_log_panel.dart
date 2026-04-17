import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenerationLogPanel extends StatefulWidget {
  final List<String> logs;
  const GenerationLogPanel({super.key, required this.logs});

  @override
  State<GenerationLogPanel> createState() => _GenerationLogPanelState();
}

class _GenerationLogPanelState extends State<GenerationLogPanel> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(GenerationLogPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-scroll to bottom when new logs arrive
    if (widget.logs.length != oldWidget.logs.length) {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            _PulsingDot(),
            SizedBox(width: 8.w),
            Text(
              'Status Log',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.blue900.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'POLLING',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.blue400,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Log terminal
        Container(
          height: 180.h,
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.slate900,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.brandBorder),
          ),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.logs.length,
            itemBuilder: (_, i) {
              final log = widget.logs[i];
              final isCompleted = log.contains('Completed');
              final isProgress = log.contains('progress');
              return Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  log,
                  style: AppTextStyles.bodyxs.copyWith(
                    color: isCompleted
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
        SizedBox(height: 8.h),
        Text(
          'Polling every 15 seconds...',
          style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate600),
        ),
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
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: AppColors.cyan400,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
