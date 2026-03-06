import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/widgets/loading/custom_circular_progress_indicator.dart';

class CustomCachedNetworkImageBuilder extends StatelessWidget {
  final String imageUrl;
  final String? errorImagePlaceholder;
  final Widget Function(BuildContext, ImageProvider<Object>) imageBuilder;
  final bool hideProgress;
  const CustomCachedNetworkImageBuilder({
    super.key,
    required this.imageUrl,
    this.errorImagePlaceholder,
    required this.imageBuilder,
    this.hideProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: imageBuilder,
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(errorImagePlaceholder ?? AppImages.pfp),
          ),
          shape: BoxShape.circle,
        ),
      ),
      progressIndicatorBuilder: hideProgress
          ? null
          : (context, url, progress) => Center(
              child: Skeleton.replace(
                replacement: const SizedBox.shrink(),
                child: CustomCircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
            ),
    );
  }
}
