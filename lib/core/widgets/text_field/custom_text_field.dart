import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final int maxLines;
  final int minLines;
  final double? borderRadius;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final void Function(PointerDownEvent)? onTapOutside;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final void Function(String)? onChanged;
  const CustomTextField({
    super.key,
    required this.text,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.style,
    this.hintStyle,
    this.borderRadius,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.onTapOutside,
    this.focusNode,
    this.autofocus = false,
    this.borderColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      scrollPadding: EdgeInsets.only(bottom: 40.h),
      obscureText: obscureText,
      controller: controller,
      readOnly: readOnly,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      onSubmitted: onSubmitted,
      onTapOutside: onTapOutside,
      autofocus: autofocus,
      onChanged: onChanged,
      textInputAction: textInputAction,
      style: style ?? AppTextStyles.bodymedium.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.gray900,
        hintText: text,
        hintStyle:
            hintStyle ??
            AppTextStyles.bodymedium.copyWith(color: AppColors.gray500),
        errorStyle: AppTextStyles.bodymedium.copyWith(color: AppColors.rose400),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),

        focusedBorder: _buildBorder(
          color: borderColor ?? AppColors.customButtonBorder,
        ),
        errorBorder: _buildBorder(
          color: borderColor ?? AppColors.customTextFormFieldBorder,
        ),
        focusedErrorBorder: _buildBorder(
          color: borderColor ?? AppColors.customTextFormFieldBorder,
        ),
        enabledBorder: _buildBorder(
          color: borderColor ?? AppColors.customTextFormFieldBorder,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16.r)),
      borderSide: BorderSide(color: color),
    );
  }
}
