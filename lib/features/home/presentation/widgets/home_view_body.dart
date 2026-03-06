import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/features/home/presentation/views/scientist_credits_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/constants/app_images.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar
        const HomeSidebar(),

        // Main Content
        Expanded(
          child: Container(
            color: AppColors.authBackground,
            child: Column(
              children: [
                // Header
                const HomeHeader(),

                // Content Feed
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 32.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Scientific Feed',
                              style: AppTextStyles.h1.copyWith(fontSize: 28.sp),
                            ),
                            const OperationsDropdown(),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        const NewsFeed(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      color: AppColors.authCardBackground,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Image.asset(AppImages.logo, width: 40.w),
                SizedBox(width: 12.w),
                Text(
                  'AiLixir',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.brandBlue,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 60.h),

          // Nav Items
          _navItem(Icons.dashboard_outlined, 'Research Feed', isActive: true),
          _navItem(Icons.science_outlined, 'Molecule Lab'),
          _navItem(Icons.folder_open_outlined, 'My Projects'),
          _navItem(Icons.hub_outlined, 'Neural Models'),
          const Spacer(),
          _navItem(
            Icons.diversity_3,
            "Esteemed Scientists",
            context: context,
            navRoute: ScientistCreditView.routeName,
          ),
          _navItem(Icons.settings_outlined, 'Settings'),
          _navItem(Icons.logout, 'Sign Out', color: AppColors.red400),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label, {
    bool isActive = false,
    Color? color,
    String? navRoute,
    BuildContext? context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.brandBlue.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? AppColors.brandBlue
              : (color ?? AppColors.authTextSecondary),
          size: 24.sp,
        ),
        title: Text(
          label,
          style: AppTextStyles.bodymedium.copyWith(
            color: isActive
                ? AppColors.white
                : (color ?? AppColors.authTextSecondary),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (context != null && navRoute != null) {
            context.navigateTo(navRoute);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.brandBorder)),
      ),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.authCardBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.brandBorder),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.authTextSecondary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                            'Search molecular structures, research papers...',
                        hintStyle: AppTextStyles.bodysmall.copyWith(
                          color: AppColors.authTextSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                      style: AppTextStyles.bodymedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 40.w),

          // Actions
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.white),
            onPressed: () {},
          ),
          SizedBox(width: 12.w),

          // Profile
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.authCardBackground,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: AppColors.brandBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.brandBlue,
                  child: const Text(
                    'JD',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Dr. Jane Doe',
                  style: AppTextStyles.labelmedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.authTextSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OperationsDropdown extends StatelessWidget {
  const OperationsDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.authCardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        children: [
          Text(
            'Sort by: Latest Discovery',
            style: AppTextStyles.labelmedium.copyWith(color: AppColors.white),
          ),
          SizedBox(width: 8.w),
          const Icon(Icons.filter_list, color: AppColors.brandBlue, size: 20),
        ],
      ),
    );
  }
}

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 32.w,
        mainAxisSpacing: 32.h,
        childAspectRatio: 1.4,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const FeedCard();
      },
    );
  }
}

class FeedCard extends StatelessWidget {
  const FeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.authCardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic Area
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(23.r)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.brandBlue.withOpacity(0.1),
                    AppColors.brandBorder.withOpacity(0.5),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.biotech,
                  size: 80.sp,
                  color: AppColors.brandBlue.withOpacity(0.3),
                ),
              ),
            ),
          ),

          // Info Area
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brandBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Protein Binding',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.brandBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Optimizing ACE2 inhibitor structure for enhanced affinity',
                        style: AppTextStyles.h4,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _metric('Affinity', '-9.2 kcal/mol'),
                          SizedBox(width: 16.w),
                          _metric('Confidence', '94%'),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.authTextSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.authTextSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelsmall.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
