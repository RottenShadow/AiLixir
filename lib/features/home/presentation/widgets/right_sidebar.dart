import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/features/awards/presentation/views/awards_view.dart';
import 'package:ailixir/features/scientists/presentation/views/scientist_credits_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // Never grow wider than 320 logical-sp, never shrink below 220
      constraints: BoxConstraints(minWidth: 220.w, maxWidth: 320.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          children: [
            _SideCard(
              title: 'Global Awards',
              trailing: ElevatedButton(
                onPressed: () {
                  context.navigateTo(AwardsView.routeName, arguments: "");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View All',
                  style: TextStyle(color: AppColors.brandBlue, fontSize: 11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AwardTile(
                    icon: Icons.emoji_events,
                    label: 'Lasker Award',
                    sub: 'Medical Research',
                  ),
                  _AwardTile(
                    icon: Icons.science_outlined,
                    label: 'Nobel Prize',
                    sub: 'Chemistry 2024',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            _TapableSideCard(
              onTap: () {
                context.navigateTo(ScientistCreditView.routeName);
              },
              title: 'Top Scientists',
              trailing: Row(
                children: [
                  _TabPill(label: 'Monthly', active: true),
                  SizedBox(width: 6.w),
                  _TabPill(label: 'All-time', active: false),
                ],
              ),
              child: const Column(
                children: [
                  _ScientistRow(
                    rank: 1,
                    name: 'Dr. Sarah Jenkins',
                    sub: 'Stanford • Proteomics',
                    impact: '2.4k',
                  ),
                  _ScientistRow(
                    rank: 2,
                    name: 'Prof. Chen Wei',
                    sub: 'Tsinghua • ML Lab',
                    impact: '2.1k',
                  ),
                  _ScientistRow(
                    rank: 3,
                    name: 'Dr. Elena Rodriguez',
                    sub: 'Oxford • Oncology',
                    impact: '1.9k',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            const _AdCard(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SideCard extends StatelessWidget {
  final String title;
  final Widget trailing;
  final Widget child;

  const _SideCard({
    required this.title,
    required this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, style: AppTextStyles.h4)),
              trailing,
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _TapableSideCard extends StatelessWidget {
  final String title;
  final Widget trailing;
  final Widget child;
  final void Function() onTap;

  const _TapableSideCard({
    required this.title,
    required this.trailing,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.brandBlue.withAlpha(51),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.brandBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(title, style: AppTextStyles.h4)),
                trailing,
              ],
            ),
            SizedBox(height: 16.h),
            child,
          ],
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────

class _AwardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;

  const _AwardTile({
    required this.icon,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.brandBlue, size: 28.sp),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.labelsmall.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          sub,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.authTextSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TabPill extends StatelessWidget {
  final String label;
  final bool active;

  const _TabPill({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: active
            ? AppColors.brandBlue.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: active ? AppColors.brandBlue : AppColors.brandBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.brandBlue : AppColors.authTextSecondary,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ScientistRow extends StatelessWidget {
  final int rank;
  final String name;
  final String sub;
  final String impact;

  const _ScientistRow({
    required this.rank,
    required this.name,
    required this.sub,
    required this.impact,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Text(
            '$rank',
            style: AppTextStyles.labelsmall.copyWith(
              color: AppColors.brandBlue,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.labelsmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sub,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            impact,
            style: AppTextStyles.labelsmall.copyWith(
              color: AppColors.brandBlue,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AdCard extends StatelessWidget {
  const _AdCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandBlue, AppColors.brandBlue.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Molecular Suite',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            'Discover our molecular screening suite for faster lead identification.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
