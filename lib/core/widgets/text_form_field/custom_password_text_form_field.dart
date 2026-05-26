import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/utils/validators/app_validators.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A password variant of [CustomTextFormField] with a built-in
/// visibility toggle. Inherits all auth-style decoration.
class CustomPasswordTextFormField extends StatefulWidget {
  final String hint;
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final AppValidatorType validatorType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;

  const CustomPasswordTextFormField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.validator,
    this.validatorType = AppValidatorType.password,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
  });

  @override
  State<CustomPasswordTextFormField> createState() =>
      _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hint: widget.hint,
      label: widget.label,
      controller: widget.controller,
      validator: widget.validator,
      validatorType: widget.validatorType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted ??
          (_) => FocusScope.of(context).nextFocus(),
      obscureText: !_isVisible,
      fillColor: widget.fillColor,
      borderColor: widget.borderColor,
      focusedBorderColor: widget.focusedBorderColor,
      borderRadius: widget.borderRadius,
      prefixIcon: Icon(
        Icons.lock_outline,
        color: AppColors.slate400,
        size: 18.sp,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _isVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.authTextSecondary,
          size: 20.sp,
        ),
        splashColor: Colors.transparent,
        onPressed: () => setState(() => _isVisible = !_isVisible),
      ),
    );
  }
}
