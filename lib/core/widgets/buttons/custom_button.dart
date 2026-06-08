import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

/// A flexible button widget that covers two main use-cases:
///
/// 1. **Icon / custom-child button** (original behaviour) — pass [child]
///    directly. Defaults to a circular shape.
///
/// 2. **Full-width primary button** — pass [text] to get the branded blue
///    gradient button with an optional loading spinner and arrow icon.
///
/// All decoration properties ([backgroundColor], [gradient], [border],
/// [borderRadius], [shape], [padding]) are fully overridable.
class CustomButton extends StatelessWidget {
  // ── Content ──────────────────────────────────────────────────────────────
  /// Provide either [text] (for the primary text button style) or [child]
  /// (for a fully custom interior). [text] takes precedence.
  final String? text;
  final Widget? child;

  // ── Behaviour ─────────────────────────────────────────────────────────────
  final VoidCallback? onTap;

  /// Shows a [CircularProgressIndicator] in place of the content and
  /// disables the tap. Only relevant when [text] is provided.
  final bool isLoading;

  /// When [text] is provided, show the trailing icon.
  /// Defaults to `false`.
  final bool showIcon;
  final IconData icon;

  // ── Size ──────────────────────────────────────────────────────────────────
  final double? width;
  final double? height;

  // ── Decoration overrides ──────────────────────────────────────────────────
  final Color? backgroundColor;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final BoxShape? shape;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  // ── Style overrides ───────────────────────────────────────────────────────
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.isLoading = false,
    this.icon = Icons.arrow_forward,
    this.showIcon = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.gradient,
    this.boxShadow,
    this.padding,
    this.shape,
    this.border,
    this.borderRadius,
    this.textStyle,
  }) : assert(text != null || child != null, 'Provide either text or child.');

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get _isPrimary => text != null;

  Gradient get _defaultGradient =>
      const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]);

  List<BoxShadow> get _defaultShadow => [
    BoxShadow(
      color: AppColors.brandBlue.withValues(alpha: 0.4),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isPrimary) return _buildPrimary(context);
    return _buildCustom(context);
  }

  // ── Primary (text) button ─────────────────────────────────────────────────

  Widget _buildPrimary(BuildContext context) {
    // final double btnHeight = height ?? 56.h;
    bool isColorProvided = backgroundColor != null;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        gradient: isColorProvided ? null : gradient ?? _defaultGradient,
        color: gradient == null && isColorProvided ? backgroundColor : null,
        border: border,
        boxShadow: isColorProvided ? null : boxShadow ?? _defaultShadow,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                (borderRadius as BorderRadius?) ?? BorderRadius.circular(12.r),
          ),
          padding:
              padding as EdgeInsets? ??
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text!,
                    style:
                        textStyle ??
                        AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (showIcon) ...[
                    SizedBox(width: 8.w),
                    Icon(icon, color: Colors.white, size: 20.sp),
                  ],
                ],
              ),
      ),
    );
  }

  // ── Custom (child) button ─────────────────────────────────────────────────

  Widget _buildCustom(BuildContext context) {
    return InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
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
