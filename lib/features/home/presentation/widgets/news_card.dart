import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/home/domain/entities/news_entity.dart';

class NewsCard extends StatefulWidget {
  final NewsEntity news;

  const NewsCard({super.key, required this.news});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard>
    with SingleTickerProviderStateMixin {
  bool _bookmarked = false;
  late final AnimationController _bookmarkCtrl;
  late final Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    _bookmarkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _bookmarkScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_bookmarkCtrl);
  }

  @override
  void dispose() {
    _bookmarkCtrl.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() => _bookmarked = !_bookmarked);
    _bookmarkCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.news;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: content ──────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag + time row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: n.tagColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        n.tag,
                        style: AppTextStyles.caption.copyWith(
                          color: n.tagColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '• ${n.timeAgo}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  n.title,
                  style: AppTextStyles.h4.copyWith(fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  n.body,
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.authTextSecondary,
                    height: 1.6,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                // Actions row
                Row(
                  children: [
                    ActionButton(label: n.primaryAction, filled: true),
                    SizedBox(width: 12.w),
                    // ─── Bookmark toggle ───────────────
                    ScaleTransition(
                      scale: _bookmarkScale,
                      child: GestureDetector(
                        onTap: _toggleBookmark,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: _bookmarked
                                ? AppColors.brandBlue.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: _bookmarked
                                  ? AppColors.brandBlue.withOpacity(0.4)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Icon(
                            _bookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            color: _bookmarked
                                ? AppColors.brandBlue
                                : AppColors.authTextSecondary,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          // ── Right: icon thumbnail ───────────────
          Container(
            width: 170.w,
            height: 130.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brandBlue.withOpacity(0.08),
                  AppColors.brandBorder.withOpacity(0.6),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                n.icon,
                size: 52.sp,
                color: AppColors.brandBlue.withOpacity(0.25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared action button
// ─────────────────────────────────────────────────────────────────────────────

class ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const ActionButton({
    super.key,
    required this.label,
    this.filled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: filled ? AppColors.brandBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: filled ? AppColors.brandBlue : AppColors.brandBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelsmall.copyWith(
                color: filled ? Colors.white : AppColors.authTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (filled) ...[
              SizedBox(width: 6.w),
              Icon(Icons.arrow_forward, size: 14.sp, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
