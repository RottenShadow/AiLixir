import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final BoxShape? shape;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  const CustomButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.padding,
    this.shape,
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.gray400,
          shape: shape ?? BoxShape.circle,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          border: border,
          gradient: gradient,
        ),
        padding: padding ?? const EdgeInsets.all(8),
        child: FittedBox(child: child),
      ),
    );
  }
}
