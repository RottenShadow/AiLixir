import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/widgets/loading/custom_circular_progress_indicator.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String errorImagePlaceholder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.errorImagePlaceholder = AppImages.pfp,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: Skeleton.replace(
          replacement: const SizedBox.shrink(),
          child: CustomCircularProgressIndicator(value: progress.progress),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(errorImagePlaceholder),
          ),
          shape: BoxShape.circle,
        ),
      ),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
