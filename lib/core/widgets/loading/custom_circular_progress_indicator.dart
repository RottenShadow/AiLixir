import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double? value;
  const CustomCircularProgressIndicator({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple500),
      value: value,
    );
  }
}
