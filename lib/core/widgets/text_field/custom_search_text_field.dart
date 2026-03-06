import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  final void Function(String)? onChanged;
  const CustomSearchTextField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      prefixIcon: const Icon(Icons.search),
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.search,
      text: 'Search ...',
    );
  }
}
