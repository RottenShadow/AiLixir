import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/validators/app_validators.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final TextInputAction? textInputAction;
  final String? Function(String?)? priorityValidator;
  final AppValidatorType validatorType;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const CustomTextFormField({
    super.key,
    required this.text,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.validatorType = AppValidatorType.noValidator,
    this.priorityValidator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (priorityValidator != null) return priorityValidator!(value);
        return AppValidators.validate(validatorType, value!);
      },
      onTap: onTap,
      scrollPadding: EdgeInsets.only(bottom: 40.h),
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: AppTextStyles.bodymedium.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.gray900,
        hintText: text,
        hintStyle: AppTextStyles.bodymedium.copyWith(color: AppColors.gray500),
        errorStyle: AppTextStyles.bodymedium.copyWith(color: AppColors.rose400),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),

        focusedBorder: _buildBorder(color: AppColors.customButtonBorder),
        errorBorder: _buildBorder(color: AppColors.customTextFormFieldBorder),
        focusedErrorBorder: _buildBorder(
          color: AppColors.customTextFormFieldBorder,
        ),
        enabledBorder: _buildBorder(color: AppColors.customTextFormFieldBorder),
      ),
    );
  }

  OutlineInputBorder _buildBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.r)),
      borderSide: BorderSide(color: color),
    );
  }
}
