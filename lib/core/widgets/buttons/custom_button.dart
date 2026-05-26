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
///    Set [isFullWidth] to `false` to let it size to its content.
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

  /// When [text] is provided, show the trailing arrow icon.
  /// Defaults to `true`.
  final bool showArrow;

  // ── Size ──────────────────────────────────────────────────────────────────
  final double? width;
  final double? height;

  /// When `true` (default when [text] is provided) the button stretches to
  /// fill its parent's width.
  final bool? isFullWidth;

  // ── Decoration overrides ──────────────────────────────────────────────────
  final Color? backgroundColor;
  final Gradient? gradient;
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
    this.showArrow = true,
    this.width,
    this.height,
    this.isFullWidth,
    this.backgroundColor,
    this.gradient,
    this.padding,
    this.shape,
    this.border,
    this.borderRadius,
    this.textStyle,
  }) : assert(
          text != null || child != null,
          'Provide either text or child.',
        );

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get _isPrimary => text != null;

  Gradient get _defaultGradient => const LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
      );

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
    final bool fullWidth = isFullWidth ?? true;
    final double btnHeight = height ?? 56.h;

    return Container(
      width: fullWidth ? double.infinity : width,
      height: btnHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        gradient: gradient ?? _defaultGradient,
        color: gradient == null && backgroundColor != null
            ? backgroundColor
            : null,
        border: border,
        boxShadow: _defaultShadow,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: (borderRadius as BorderRadius?) ??
                BorderRadius.circular(12.r),
          ),
          padding: padding as EdgeInsets? ??
              EdgeInsets.symmetric(horizontal: 24.w),
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
                    style: textStyle ??
                        AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (showArrow) ...[
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward,
                        color: Colors.white, size: 20.sp),
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
