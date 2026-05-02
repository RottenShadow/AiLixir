import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A tag/chip input widget — press Enter or comma to add a tag.
class DrTagInput extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;
  final Color accentColor;

  const DrTagInput({
    super.key,
    required this.label,
    required this.hint,
    required this.tags,
    required this.onTagsChanged,
    this.accentColor = const Color(0xFF1E69FF),
  });

  @override
  State<DrTagInput> createState() => _DrTagInputState();
}

class _DrTagInputState extends State<DrTagInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  void _addTag(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (!widget.tags.contains(trimmed)) {
      widget.onTagsChanged([...widget.tags, trimmed]);
    }
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _removeTag(String tag) {
    widget.onTagsChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelmedium.copyWith(
            color: AppColors.authTextSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Container(
            constraints: BoxConstraints(minHeight: 52.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.slate900,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? widget.accentColor.withOpacity(0.6)
                    : AppColors.brandBorder,
              ),
            ),
            child: Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...widget.tags.map(
                  (tag) => _TagChip(
                    label: tag,
                    accentColor: widget.accentColor,
                    onRemove: () => _removeTag(tag),
                  ),
                ),
                SizedBox(
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace &&
                          _controller.text.isEmpty &&
                          widget.tags.isNotEmpty) {
                        _removeTag(widget.tags.last);
                      }
                    },
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: AppTextStyles.bodysmall.copyWith(
                        color: AppColors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.tags.isEmpty
                            ? widget.hint
                            : 'Add more...',
                        hintStyle: AppTextStyles.bodysmall.copyWith(
                          color: AppColors.slate500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                      ),
                      onSubmitted: _addTag,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Press Enter to add',
          style: AppTextStyles.caption.copyWith(color: AppColors.slate500),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color accentColor;
  final VoidCallback onRemove;

  const _TagChip({
    required this.label,
    required this.accentColor,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: accentColor.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 5.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 12.sp, color: accentColor),
          ),
        ],
      ),
    );
  }
}
