import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/widgets/cached_network_image/custom_cached_network_image_builder.dart';

class CustomAvatarImage extends StatelessWidget {
  final String image;
  final String? errorImagePlaceholder;
  final bool showBorder;
  final Color color;
  final double? radius;

  const CustomAvatarImage({
    super.key,
    required this.image,
    this.errorImagePlaceholder,
    this.showBorder = false,
    this.color = AppColors.fuchsia600,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 28.r,
      child: CustomCachedNetworkImageBuilder(
        imageUrl: image,
        errorImagePlaceholder: errorImagePlaceholder,
        imageBuilder: (context, img) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: img,
              // fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
            border: showBorder
                ? Border.all(
                    color: color,
                    width: 3.w,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
