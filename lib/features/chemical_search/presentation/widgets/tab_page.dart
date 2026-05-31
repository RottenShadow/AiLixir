import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/chemical_search/presentation/cubits/chemical_search_cubit.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/log_panel.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/search_form.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/result_card.dart';

class TabPage extends StatefulWidget {
  final ChemicalSearchCubit cubit;

  const TabPage({super.key, required this.cubit});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final _smilesCtrl = TextEditingController();
  final _topKCtrl = TextEditingController(text: '3');

  @override
  void dispose() {
    _smilesCtrl.dispose();
    _topKCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final smiles = _smilesCtrl.text.trim();
    if (smiles.isEmpty) return;
    final topK = int.tryParse(_topKCtrl.text.trim()) ?? 3;
    widget.cubit.search(smiles: smiles, topK: topK.clamp(1, 100));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChemicalSearchCubit, ChemicalSearchState>(
      bloc: widget.cubit,
      builder: (context, state) {
        final isLoading = state is ChemicalSearchLoading;
        final hasResults =
            state is ChemicalSearchSuccess ||
            state is ChemicalSearchError ||
            isLoading;

        return Column(
          children: [
            SearchForm(
              smilesController: _smilesCtrl,
              topKController: _topKCtrl,
              isLoading: isLoading,
              onSubmit: _submit,
              onReset: hasResults
                  ? () {
                      widget.cubit.reset();
                      _smilesCtrl.clear();
                      _topKCtrl.text = '3';
                    }
                  : null,
            ),
            SizedBox(height: 20.h),
            if (state.logs.isNotEmpty) ...[
              LogPanel(logs: state.logs),
              SizedBox(height: 20.h),
            ],
            if (state is ChemicalSearchSuccess) _buildResultsSection(state),
            if (state is ChemicalSearchError) _buildError(state),
          ],
        );
      },
    );
  }

  Widget _buildResultsSection(ChemicalSearchSuccess state) {
    final response = state.response;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultHeader(state.smiles, response.results.length),
        SizedBox(height: 16.h),
        if (state.smiles.isNotEmpty) _buildQuerySmilesBox(state.smiles),
        SizedBox(height: 16.h),
        ...response.results.map(
          (r) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: ResultCard(compound: r, isFullRag: response.isFullRag),
          ),
        ),
      ],
    );
  }

  Widget _buildResultHeader(String querySmiles, int count) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppColors.emerald400,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald400.withOpacity(0.5),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          'Search Results',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        SizedBox(width: 10.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppColors.slate700.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            '$count compound${count == 1 ? '' : 's'} found',
            style: AppTextStyles.labelsmall.copyWith(color: AppColors.slate400),
          ),
        ),
      ],
    );
  }

  Widget _buildQuerySmilesBox(String querySmiles) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.emerald900.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.emerald700.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.input, color: AppColors.emerald400, size: 12.sp),
              SizedBox(width: 6.w),
              Text(
                'QUERY SMILES',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.emerald400.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          SelectableText(
            querySmiles,
            style: AppTextStyles.bodysmall.copyWith(
              color: AppColors.emerald300,
              fontFamily: 'monospace',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(ChemicalSearchError state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.red900.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.red700.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.red400, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Failed',
                  style: AppTextStyles.labelmedium.copyWith(
                    color: AppColors.red400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                SelectableText(
                  state.message,
                  style: AppTextStyles.bodysmall.copyWith(
                    color: AppColors.red200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
