import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/home/domain/entities/news_entity.dart';
import 'package:ailixir/features/home/domain/entities/news_filter.dart';
import 'news_card.dart';
import 'news_filter_tabs.dart';
import 'right_sidebar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Static news seed data  (replace with BLoC / repository later)
// ─────────────────────────────────────────────────────────────────────────────
List<NewsEntity> get _allNews => NewsEntity.getTestData;

// ─────────────────────────────────────────────────────────────────────────────

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  String _selectedFilterId = NewsFilter.all.first.id; // 'all'

  List<NewsEntity> get _filtered => _selectedFilterId == 'all'
      ? _allNews
      : _allNews
            .where((n) => n.categories.contains(_selectedFilterId))
            .toList();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Main Feed ─────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Global Pharma & AI News',
                  style: AppTextStyles.h1.copyWith(fontSize: 28.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Real-time intelligence on drug discovery and clinical advancements.',
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.authTextSecondary,
                  ),
                ),
                SizedBox(height: 28.h),

                // ── Filter tabs ────────────────────────
                NewsFilterTabs(
                  filters: NewsFilter.all,
                  selectedId: _selectedFilterId,
                  onFilterSelected: (id) =>
                      setState(() => _selectedFilterId = id),
                ),
                SizedBox(height: 24.h),

                // ── News cards ─────────────────────────
                ..._filtered.map(
                  (news) => Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: NewsCard(news: news),
                  ),
                ),

                if (_filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: Text(
                        'No articles found for this category.',
                        style: AppTextStyles.bodysmall.copyWith(
                          color: AppColors.authTextSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ── Right Sidebar ──────────────────────────────
        const RightSidebar(),
      ],
    );
  }
}
