import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBrandLogo extends StatelessWidget {
  final double? size;
  final bool showText;
  const AuthBrandLogo({super.key, this.size, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppImages.logo, width: 32.w),
        SizedBox(width: 10.w),
        GradientText(
          text: 'Ailixir',
          style: TextStyle(
            fontFamily: 'UniNeueTrial',
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
