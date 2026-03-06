import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/utils/validators/app_validators.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? priorityValidator;
  final AppValidatorType validatorType;
  final TextInputAction? textInputAction;

  const CustomPasswordTextFormField({
    super.key,
    required this.controller,
    required this.text,
    this.priorityValidator,
    this.validatorType = AppValidatorType.password,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<CustomPasswordTextFormField> createState() =>
      _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      text: widget.text,
      controller: widget.controller,
      validatorType: widget.validatorType,
      priorityValidator: widget.priorityValidator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (focus) => FocusScope.of(context).nextFocus(),
      obscureText: !isVisible,
      suffixIcon: IconButton(
        icon: isVisible
            ? const Icon(Icons.visibility_off_outlined)
            : const Icon(Icons.visibility_outlined),
        color: AppColors.white,
        splashColor: Colors.transparent,
        onPressed: () {
          setState(() => isVisible = !isVisible);
        },
      ),
    );
  }
}
