import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/validators/app_validators.dart';

/// A configurable form field that matches the app's dark auth-style design.
///
/// Supports an optional [label] rendered above the field (uppercased), a
/// [topTrailing] widget placed to the right of the label (e.g. "Forgot
/// password?" link), prefix/suffix icons, validation, and all common
/// TextFormField options.
class CustomTextFormField extends StatelessWidget {
  // ── Content ──────────────────────────────────────────────────────────────
  final String hint;
  final String? label;
  final Widget? topTrailing;

  // ── Controller & state ───────────────────────────────────────────────────
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;

  // ── Keyboard ─────────────────────────────────────────────────────────────
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // ── Callbacks ────────────────────────────────────────────────────────────
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;

  // ── Validation ───────────────────────────────────────────────────────────
  final String? Function(String?)? validator;
  final AppValidatorType validatorType;

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
  final TextStyle? labelStyle;

  const CustomTextFormField({
    super.key,
    required this.hint,
    this.label,
    this.topTrailing,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.validator,
    this.validatorType = AppValidatorType.noValidator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.style,
    this.hintStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 10.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!.toUpperCase(),
                style: (labelStyle ?? AppTextStyles.labelmedium).copyWith(
                  color: AppColors.slate400,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
              if (topTrailing != null) topTrailing!,
            ],
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          scrollPadding: EdgeInsets.only(bottom: 40.h),
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          validator: (value) {
            if (validator != null) return validator!(value);
            return AppValidators.validate(validatorType, value ?? '');
          },
          style: style ??
              AppTextStyles.bodymedium.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle ??
                AppTextStyles.bodymedium.copyWith(color: AppColors.slate500),
            errorStyle:
                AppTextStyles.bodymedium.copyWith(color: AppColors.rose400),
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
