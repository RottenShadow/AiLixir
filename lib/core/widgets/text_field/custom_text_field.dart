import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

/// A configurable [TextField] (no validation) that matches the app's
/// dark auth-style design. Use [CustomTextFormField] when you need
/// validation inside a [Form].
class CustomTextField extends StatelessWidget {
  // ── Content ──────────────────────────────────────────────────────────────
  final String hint;
  final String? label;

  // ── Controller & state ───────────────────────────────────────────────────
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final int maxLines;
  final int minLines;

  // ── Keyboard ─────────────────────────────────────────────────────────────
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // ── Callbacks ────────────────────────────────────────────────────────────
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;

  // ── Decoration overrides ─────────────────────────────────────────────────
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;

  // ── Style overrides ───────────────────────────────────────────────────────
  final TextStyle? style;
  final TextStyle? hintStyle;

  const CustomTextField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.style,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 10.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: AppTextStyles.labelmedium.copyWith(
              color: AppColors.slate400,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          autofocus: autofocus,
          focusNode: focusNode,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          scrollPadding: EdgeInsets.only(bottom: 40.h),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTapOutside: onTapOutside,
          style: style ??
              AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle ??
                AppTextStyles.bodymedium.copyWith(color: AppColors.slate500),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor:
                fillColor ?? AppColors.slate700.withValues(alpha: 0.45),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: _border(
              radius,
              borderColor ?? AppColors.slate600.withValues(alpha: 0.6),
            ),
            enabledBorder: _border(
              radius,
              borderColor ?? AppColors.slate600.withValues(alpha: 0.6),
            ),
            focusedBorder: _border(
              radius,
              focusedBorderColor ?? AppColors.brandBlue,
              width: 1.5,
            ),
            errorBorder: _border(radius, Colors.redAccent),
            focusedErrorBorder:
                _border(radius, Colors.redAccent, width: 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(double radius, Color color,
      {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
