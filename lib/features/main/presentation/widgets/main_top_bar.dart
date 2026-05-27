import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/widgets/gradient_text.dart';
import 'package:ailixir/features/profile/presentation/views/profile_view.dart';
import 'package:ailixir/core/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/model/user/user_cache/cached_user_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ailixir/features/auth/presentation/cubits/user_auth_cubit/user_auth_cubit.dart';

// Page index constants mirror main_view_body.dart
// 0 News Feed | 1 Molecular Lab | 2 Generation | 3 Docking | 4 MD | 5 History

class MainTopBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;

  const MainTopBar({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  // Operations is active whenever one of its 3 sub-pages is selected
  // Operations is active whenever one of its sub-pages is selected
  bool get _opsActive => selectedIndex >= 2 && selectedIndex <= 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      decoration: const BoxDecoration(
        color: AppColors.slate900,
        border: Border(bottom: BorderSide(color: AppColors.brandBorder)),
      ),
      child: Row(
        children: [
          // ── Logo ────────────────────────────────
          Image.asset(AppImages.logo, width: 32.w),
          SizedBox(width: 10.w),
          GradientText(
            text: 'Ailixir',
            style: TextStyle(
              fontFamily: 'UniNeueTrial',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.brandBlue,
              letterSpacing: 1.1,
            ),
          ),

          SizedBox(width: 36.w),

          // ── Nav Items ───────────────────────────
          _NavItem(
            icon: Icons.dashboard_outlined,
            label: 'News Feed',
            isActive: selectedIndex == 0,
            onTap: () => onNavTap(0),
          ),
          _NavItem(
            icon: Icons.science_outlined,
            label: 'Molecular Lab',
            isActive: selectedIndex == 1,
            onTap: () => onNavTap(1),
          ),
          _OperationsDropdown(isActive: _opsActive, onSelected: onNavTap),
          _NavItem(
            icon: Icons.history,
            label: 'History',
            isActive: selectedIndex == 6,
            onTap: () => onNavTap(6),
          ),

          const Spacer(),

          // ── Profile ─────────────────────────────
          _ProfileChip(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Operations Dropdown — custom dark theme
// ─────────────────────────────────────────────
class _OperationsDropdown extends StatelessWidget {
  final bool isActive;
  final ValueChanged<int> onSelected;

  const _OperationsDropdown({required this.isActive, required this.onSelected});

  static const _items = [
    (index: 2, icon: Icons.auto_awesome, label: 'New Generation'),
    (index: 3, icon: Icons.handshake_outlined, label: 'Docking'),
    (index: 4, icon: Icons.waves, label: 'MD'),
    (index: 5, icon: Icons.biotech, label: 'Drug Repurposing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Override popup theme to match the app's dark palette
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.cardBackground,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.4),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: AppColors.brandBorder),
          ),
        ),
      ),
      child: PopupMenuButton<int>(
        offset: Offset(0, 44.h),
        onSelected: onSelected,
        itemBuilder: (_) => _items
            .map(
              (e) => PopupMenuItem<int>(
                value: e.index,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Row(
                  children: [
                    Icon(e.icon, size: 16.sp, color: AppColors.brandBlue),
                    SizedBox(width: 10.w),
                    Text(
                      e.label,
                      style: AppTextStyles.bodysmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        // The visible button in the top bar
        child: _NavItemContent(
          icon: Icons.settings_outlined,
          label: 'Operations',
          isActive: isActive,
          trailing: Icon(
            Icons.keyboard_arrow_down,
            size: 14.sp,
            color: isActive ? AppColors.brandBlue : AppColors.authTextSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Single nav item (tap-based)
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: _NavItemContent(icon: icon, label: label, isActive: isActive),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared visual content for nav items
// ─────────────────────────────────────────────
class _NavItemContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Widget? trailing;

  const _NavItemContent({
    required this.icon,
    required this.label,
    required this.isActive,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.brandBlue : AppColors.authTextSecondary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.brandBlue.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.bodysmall.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 4.w), trailing!],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Profile chip
// ─────────────────────────────────────────────
class _ProfileChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = CachedUserDataModel.fromCache();

    String initials = '';
    if (user.name.isNotEmpty) {
      final parts = user.name.trim().split(' ');
      if (parts.length > 1) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.cardBackground,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.4),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: AppColors.brandBorder),
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        offset: Offset(0, 44.h),
        onSelected: (value) {
          if (value == 'logout') {
            context.read<UserAuthCubit>().forceLogout();
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem<String>(
            value: 'profile',
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16.sp,
                  color: AppColors.brandBlue,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Profile',
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              children: [
                Icon(Icons.logout, size: 16.sp, color: Colors.redAccent),
                SizedBox(width: 10.w),
                Text(
                  'Logout',
                  style: AppTextStyles.bodysmall.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.slate1000,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: AppColors.brandBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: AppColors.brandBlue,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                user.name,
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 4.w),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.authTextSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
