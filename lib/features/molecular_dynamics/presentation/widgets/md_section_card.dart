import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable section card matching the dark-themed layout in the design.
class MdSectionCard extends StatelessWidget {
  final String stepNumber;
  final String title;
  final Widget child;
  final Widget? trailing;
  final Color? accentColor;

  const MdSectionCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.child,
    this.trailing,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.violet500;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate900,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: accent, width: 3),
        ),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science_outlined, color: accent, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                '$stepNumber. $title',
                style: AppTextStyles.h5.copyWith(color: AppColors.white),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

/// Small label above an input field
class MdFieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const MdFieldLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.authTextSecondary,
              letterSpacing: 0.8,
            ),
          ),
          if (required) ...[
            SizedBox(width: 4.w),
            Text(
              '*',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.red400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Styled text field
class MdTextField extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const MdTextField({
    super.key,
    required this.hint,
    this.initialValue,
    this.onChanged,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodysmall.copyWith(
          color: AppColors.slate500,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.slate800,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.brandBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.brandBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.violet500),
        ),
      ),
    );
  }
}

/// Styled dropdown
class MdDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const MdDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.slate800,
          style: AppTextStyles.bodysmall.copyWith(color: AppColors.white),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.authTextSecondary,
            size: 18.sp,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Toggle switch row
class MdToggleRow extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const MdToggleRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.brandBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelsmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.authTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.violet500,
            activeTrackColor: AppColors.violet500.withOpacity(0.3),
            inactiveThumbColor: AppColors.slate500,
            inactiveTrackColor: AppColors.slate700,
          ),
        ],
      ),
    );
  }
}

/// Slider with label and value badge
class MdSliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;

  const MdSliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.authTextSecondary,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.violet500.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: AppColors.violet500.withOpacity(0.4),
                ),
              ),
              child: Text(
                '${value % 1 == 0 ? value.toInt() : value.toStringAsFixed(1)} $unit',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.violet400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.violet500,
            inactiveTrackColor: AppColors.slate700,
            thumbColor: AppColors.violet400,
            overlayColor: AppColors.violet500.withOpacity(0.15),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${min % 1 == 0 ? min.toInt() : min} $unit',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.slate500,
              ),
            ),
            Text(
              '${max % 1 == 0 ? max.toInt() : max} $unit',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.slate500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Checkbox row
class MdCheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const MdCheckRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.violet500,
            checkColor: AppColors.white,
            side: BorderSide(color: AppColors.slate500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppTextStyles.labelsmall.copyWith(
            color: AppColors.authTextSecondary,
          ),
        ),
      ],
    );
  }
}

/// Small badge pill
class MdBadge extends StatelessWidget {
  final String text;
  final Color color;

  const MdBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
