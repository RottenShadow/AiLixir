import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/widgets/cached_network_image/custom_cached_network_image_builder.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';

class CustomPhotoView extends StatelessWidget {
  static const String routeName = '/profile-photo-view';

  final String? imageUrl;

  const CustomPhotoView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          if (imageUrl != null &&
              (imageUrl!.startsWith('/') ||
                  imageUrl!.contains(':\\') ||
                  imageUrl!.startsWith('file'))) ...[
            PhotoView(
              imageProvider: Image.file(File(imageUrl!)).image,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 3,
              tightMode: true,
              strictScale: true,
            ),
          ] else ...[
            CustomCachedNetworkImageBuilder(
              imageUrl: imageUrl!,
              imageBuilder: (context, imgProvider) => PhotoView(
                imageProvider: imgProvider,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 3,
                tightMode: true,
                strictScale: true,
              ),
            ),
          ],
          Positioned(
            top: 64.h,
            left: 8.w,
            child: IconButton(
              onPressed: () => context.canPop() ? context.goBack() : null,
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
