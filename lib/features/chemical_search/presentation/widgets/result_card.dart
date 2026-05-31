import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/chemical_search/domain/entities/chemical_search_entity.dart';
import 'package:ailixir/features/chemical_search/presentation/widgets/chemical_search_shared.dart';

class ResultCard extends StatefulWidget {
  final ChemicalSearchResultEntity compound;
  final bool isFullRag;

  const ResultCard({
    super.key,
    required this.compound,
    required this.isFullRag,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool _expanded = false;
  bool _imgError = false;

  @override
  void initState() {
    super.initState();
    _imgError = false;
  }

  @override
  void didUpdateWidget(covariant ResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.compound.smiles != widget.compound.smiles) {
      _imgError = false;
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final compound = widget.compound;
    final isExact = compound.similarityScore >= 1.0;
    final rColor = rankColor(compound.rank);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.03),
        border: Border.all(
          color: isExact
              ? AppColors.emerald400.withOpacity(0.2)
              : AppColors.white.withOpacity(0.07),
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: isExact
            ? [BoxShadow(color: AppColors.emerald400.withOpacity(0.07), blurRadius: 24)]
            : null,
      ),
      child: SelectionArea(
        child: Column(
          children: [
            _buildHeaderStrip(compound, rColor, isExact),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePanel(compound),
                _buildContentPanel(compound),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStrip(
    ChemicalSearchResultEntity compound,
    Color color,
    bool isExact,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.015),
        border: Border(bottom: BorderSide(color: AppColors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          RankBadge(rank: compound.rank, color: color),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              compound.displayName,
              style: AppTextStyles.bodymedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SearchBadge(label: 'CID: ${compound.cid}', color: AppColors.blue400),
          SizedBox(width: 8.w),
          if (isExact)
            SearchBadge(label: 'EXACT MATCH', color: AppColors.emerald400),
        ],
      ),
    );
  }

  Widget _buildImagePanel(ChemicalSearchResultEntity compound) {
    return Container(
      width: 180.w,
      constraints: BoxConstraints(minHeight: 160.h),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.02),
        border: Border(
          right: BorderSide(color: AppColors.white.withOpacity(0.05)),
        ),
      ),
      child: Center(
        child: _imgError
            ? _buildPlaceholderImage()
            : ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  compound.imageUrl,
                  width: 148.w,
                  height: 148.h,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildLoadingImage();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    if (!_imgError) {
                      Future.microtask(() {
                        if (mounted) setState(() => _imgError = true);
                      });
                    }
                    return _buildPlaceholderImage();
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      width: 148.w,
      height: 148.h,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.slate500,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 148.w,
      height: 148.h,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: AppColors.white.withOpacity(0.2),
            size: 32.sp,
          ),
          SizedBox(height: 6.h),
          Text(
            'Structure\nImage',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPanel(ChemicalSearchResultEntity compound) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreSection(compound.similarityScore),
            SizedBox(height: 12.h),
            _buildSmilesBox(compound.smiles),
            SizedBox(height: 12.h),
            if (widget.isFullRag) _buildExplanationToggle(compound),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(double score) {
    final pct = (score * 100).round();
    final color = scoreColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TANIMOTO SIMILARITY',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.white.withOpacity(0.35),
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: score.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99.r),
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.6), color],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              score.toStringAsFixed(4),
              style: AppTextStyles.labelsmall.copyWith(
                color: color,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '$pct% similar',
          style: AppTextStyles.bodyxs.copyWith(
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSmilesBox(String smiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SMILES',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.white.withOpacity(0.35),
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: AppColors.blue400.withOpacity(0.1),
            ),
          ),
          child: SelectableText(
            smiles,
            style: AppTextStyles.bodyxs.copyWith(
              color: AppColors.blue200,
              fontFamily: 'monospace',
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationToggle(ChemicalSearchResultEntity compound) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.play_arrow,
                    size: 12.sp,
                    color: AppColors.white.withOpacity(0.5),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  _expanded ? 'HIDE EXPLANATION' : 'SHOW EXPLANATION',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.white.withOpacity(0.06)),
            ),
            child: SelectableText(
              compound.explanation ?? 'No explanation available.',
              style: AppTextStyles.bodysmall.copyWith(
                color: AppColors.white.withOpacity(0.65),
                height: 1.75,
              ),
            ),
          ),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}
