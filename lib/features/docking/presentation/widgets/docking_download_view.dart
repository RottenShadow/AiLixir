import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/services/local_storage/secure_storage_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class DockingDownloadView extends StatefulWidget {
  final String url;

  const DockingDownloadView({super.key, required this.url});

  @override
  State<DockingDownloadView> createState() => _DockingDownloadViewState();
}

class _DockingDownloadViewState extends State<DockingDownloadView> {
  final Future<String?> _tokenFuture = GetIt.I
      .get<SecureStorageService>()
      .readValue(key: AppConstants.accessTokenKey);

  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate1000,
      appBar: AppBar(
        backgroundColor: AppColors.slate900,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.white, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Download Results',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        bottom: _loading
            ? PreferredSize(
                preferredSize: Size.fromHeight(2.h),
                child: LinearProgressIndicator(
                  color: AppColors.cyan400,
                  backgroundColor: AppColors.slate800,
                ),
              )
            : null,
      ),
      body: FutureBuilder<String?>(
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.cyan400,
                ),
              ),
            );
          }
          final token = snapshot.data ?? '';
          return Stack(
            children: [
              InAppWebView(
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useHybridComposition: true,
                ),
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.url),
                  headers: {'Authorization': '${AppConstants.bearer}$token'},
                ),
                onLoadStop: (ctrl, url) {
                  if (mounted) setState(() => _loading = false);
                },

                onLoadError: (controller, url, code, message) => {
                  if (mounted) setState(() => _loading = false),
                },
              ),
              Container(
                color: AppColors.slate1000.withValues(alpha: 0.85),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_loading)
                        SizedBox(
                          width: 48.w,
                          height: 48.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.cyan400,
                          ),
                        )
                      else
                        Icon(
                          Icons.check_circle,
                          color: AppColors.emerald400,
                          size: 48.sp,
                        ),
                      SizedBox(height: 20.h),
                      Text(
                        _loading
                            ? 'Your download will start now at any moment'
                            : 'Download completed',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!_loading) ...[
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emerald600,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text('Close'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
