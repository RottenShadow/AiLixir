import 'package:ailixir/features/home/data/repos/news_repo.dart';
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

// ─────────────────────────────────────────────────────────────────────────────

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  String _selectedFilterId = NewsFilter.all.first.id; // 'all'
  List<NewsEntity> _bookmarks = [];
  final NewsRepo _repo = NewsRepo();
  bool _loading = false;
  bool _err = false;
  late ScrollController _controller;

  final List<NewsEntity> _allNews = [];
  List<NewsEntity> get _filtered => _selectedFilterId == 'all'
      ? _allNews
      : (_selectedFilterId == "saved"
            ? _bookmarks
            : _allNews
                  .where((n) => n.categories.contains(_selectedFilterId))
                  .toList());

  void getBookmarks() {
    _loading = true;
    setState(() {});
    _repo.getBookmarks().then((v) {
      v.fold(
        (f) {
          _err = true;
          _loading = false;
          setState(() {});
        },
        (v) {
          setState(() {
            _loading = false;
            _err = false;
            _bookmarks = v;
          });
        },
      );
    });
  }

  void getNews() async {
    _loading = true;
    setState(() {});
    var res = await _repo.getNews();
    res.fold(
      (f) {
        _loading = false;
        _err = true;
        setState(() {});
      },
      (v) {
        _allNews.addAll(v);
        _loading = false;
        _err = false;
        setState(() {});
      },
    );
  }

  void getNewsPaginated() async {
    setState(() {});
    var res = await _repo.getNews();
    res.fold((f) {}, (v) {
      _allNews.addAll(v);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
        getNewsPaginated();
      }
    });
  }

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
                  onFilterSelected: (id) => setState(() {
                    _selectedFilterId = id;
                    if (id == "saved") {
                      getBookmarks();
                    }
                  }),
                ),
                SizedBox(height: 24.h),

                // ── News cards ─────────────────────────
                ..._filtered.map(
                  (news) => Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: NewsCard(
                      news: news,
                      onBookmark: (id) async {
                        var res = news.bookmarked
                            ? await _repo.removeBookmark(id)
                            : await _repo.saveBookmark(id);
                        bool success = false;
                        res.fold((_) {}, (v) {
                          success = v;
                        });
                        return success;
                      },
                    ),
                  ),
                ),

                Visibility(
                  visible: _loading,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: CircularProgressIndicator(color: AppColors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: _err,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: Column(
                        children: [
                          Text(
                            'Failed to fetch articles.',
                            style: AppTextStyles.bodysmall.copyWith(
                              color: AppColors.red600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _selectedFilterId == "all"
                                  ? getNews()
                                  : getBookmarks();
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_filtered.isEmpty && !_loading && !_err)
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
