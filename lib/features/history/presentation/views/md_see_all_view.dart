import 'package:ailixir/core/entities/md_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/history/presentation/cubits/see_all_cubit/see_all_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MdSeeAllView extends StatefulWidget {
  static const routeName = '/history/md';
  const MdSeeAllView({super.key});

  @override
  State<MdSeeAllView> createState() => _MdSeeAllViewState();
}

class _MdSeeAllViewState extends State<MdSeeAllView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MdSeeAllCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.slate1000,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Molecular Dynamics History',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            Text(
              'All MD simulations',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: BlocBuilder<MdSeeAllCubit, SeeAllState<MdEntity>>(
        builder: (context, state) {
          if (state.status == SeeAllStatus.loading) {
            return Skeletonizer(
              enabled: true,
              child: _MdTable(
                items: MdEntity.createFakeData(),
                scrollController: _scrollController,
                isLoadingMore: false,
                hasMore: false,
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: Text(
                'No simulations found.',
                style: AppTextStyles.bodymedium.copyWith(
                  color: AppColors.slate400,
                ),
              ),
            );
          }

          return _MdTable(
            items: state.items,
            scrollController: _scrollController,
            isLoadingMore: state.status == SeeAllStatus.loadingMore,
            hasMore: state.hasMore,
          );
        },
      ),
    );
  }
}

class _MdTable extends StatelessWidget {
  final List<MdEntity> items;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const _MdTable({
    required this.items,
    required this.scrollController,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sticky header
        Container(
          color: AppColors.slate900,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Simulation Task',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Forcefield',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Duration',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Status',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Artifacts',
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.slate500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.brandBorder, height: 1),
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 24.h),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.brandBorder, height: 1),
            itemBuilder: (context, index) {
              if (index == items.length) {
                if (isLoadingMore) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.purple400,
                        ),
                      ),
                    ),
                  );
                }
                if (!hasMore) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Text(
                        'No more results',
                        style: AppTextStyles.bodyxs.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              return _MdRow(md: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _MdRow extends StatelessWidget {
  final MdEntity md;
  const _MdRow({required this.md});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy · hh:mm a').format(md.createdAt);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  md.simulationTask,
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  dateStr,
                  style: AppTextStyles.bodyxs.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              md.forcefield,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              md.duration,
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.slate300,
              ),
            ),
          ),
          Expanded(flex: 2, child: _StatusBadge(status: md.status)),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ArtifactBtn(label: '.PDB'),
                SizedBox(width: 8.w),
                _ArtifactBtn(label: '.DCD'),
                SizedBox(width: 8.w),
                _ArtifactBtn(label: '.LOG'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MdStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      MdStatus.completed => (
        AppColors.emerald900.withValues(alpha: 0.5),
        AppColors.emerald400,
        'COMPLETED',
      ),
      MdStatus.running => (
        AppColors.blue900.withValues(alpha: 0.5),
        AppColors.blue400,
        'RUNNING',
      ),
      MdStatus.failed => (
        AppColors.red900.withValues(alpha: 0.5),
        AppColors.red400,
        'FAILED',
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(label, style: AppTextStyles.labelsmall.copyWith(color: fg)),
    );
  }
}

class _ArtifactBtn extends StatelessWidget {
  final String label;
  const _ArtifactBtn({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: AppTextStyles.labelsmall.copyWith(color: AppColors.slate400),
      ),
    );
  }
}
