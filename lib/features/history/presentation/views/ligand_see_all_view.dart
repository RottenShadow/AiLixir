import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/custom_empty_body.dart';
import 'package:ailixir/features/history/presentation/cubits/generation_history_cubit/generation_history_cubit.dart';
import 'package:ailixir/features/history/presentation/views/ligand_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LigandSeeAllView extends StatefulWidget {
  static const routeName = '/history/ligands';
  const LigandSeeAllView({super.key});

  @override
  State<LigandSeeAllView> createState() => _LigandSeeAllViewState();
}

class _LigandSeeAllViewState extends State<LigandSeeAllView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<GenerationHistoryCubit>().loadMore();
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
              'Ligand Generation History',
              style: AppTextStyles.h4.copyWith(color: AppColors.white),
            ),
            Text(
              'All generated candidates',
              style: AppTextStyles.bodyxs.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ),
      body: BlocBuilder<GenerationHistoryCubit, GenerationHistoryState>(
        builder: (context, state) {
          final cubit = context.read<GenerationHistoryCubit>();

          if (state is GenerationHistoryLoading) {
            return Skeletonizer(
              enabled: true,
              child: _LigandList(
                items: LigandEntity.createFakeData(),
                scrollController: _scrollController,
                isLoadingMore: false,
                hasMore: false,
              ),
            );
          }

          if (state is GenerationHistoryError) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.error_outline,
                  title: 'Error',
                  subTitle: state.message,
                  actionLabel: 'Retry',
                  onAction: () => cubit.loadAll(),
                ),
              ),
            );
          }

          final items = state is GenerationHistoryLoaded
              ? state.ligands
              : (state as GenerationHistoryLoadingMore).ligands;

          if (items.isEmpty) {
            return SizedBox.expand(
              child: Center(
                child: CustomEmptyBody(
                  icon: Icons.science_outlined,
                  title: 'No Ligands Found',
                  subTitle: 'No generated ligands yet.\nStart a generation job to see results here.',
                  actionLabel: 'Refresh',
                  onAction: () => cubit.loadAll(),
                ),
              ),
            );
          }

          return _LigandList(
            items: items,
            scrollController: _scrollController,
            isLoadingMore: state is GenerationHistoryLoadingMore,
            hasMore: cubit.hasMore,
          );
        },
      ),
    );
  }
}

class _LigandList extends StatelessWidget {
  final List<LigandEntity> items;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;

  const _LigandList({
    required this.items,
    required this.scrollController,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: items.length + 1,
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
                    color: AppColors.cyan400,
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

        final ligand = items[index];
        return _LigandRow(ligand: ligand);
      },
    );
  }
}

class _LigandRow extends StatelessWidget {
  final LigandEntity ligand;
  const _LigandRow({required this.ligand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(LigandDetailsView.routeName, extra: ligand),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.slate800,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.brandBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.slate700,
                borderRadius: BorderRadius.circular(6.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'SM',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.slate300,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ligand.candidateName,
                    style: AppTextStyles.h6.copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    ligand.smiles,
                    style: AppTextStyles.bodyxs.copyWith(
                      color: AppColors.slate400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            OutlinedButton.icon(
              onPressed: () =>
                  context.push(LigandDetailsView.routeName, extra: ligand),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.cyan600),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: AppColors.cyan400,
                size: 14.sp,
              ),
              label: Text(
                'Analyze',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.cyan400,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.slate600),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(
                Icons.download_outlined,
                color: AppColors.slate300,
                size: 14.sp,
              ),
              label: Text(
                'Download .mol',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.slate300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
