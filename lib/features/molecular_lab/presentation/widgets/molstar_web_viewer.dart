import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

/// A WebView widget that loads the bundled Mol* (MolStar) molecular viewer
/// from the local Flutter asset `assets/web/viewer/index.html`.
///
/// Optional [pdbId] auto-loads a PDB entry on startup.
class MolstarWebViewer extends StatefulWidget {
  /// PDB ID to load automatically, e.g. `'7bv2'`. Pass null for an empty viewer.
  final String? pdbId;

  const MolstarWebViewer({super.key, this.pdbId});

  @override
  State<MolstarWebViewer> createState() => _MolstarWebViewerState();
}

class _MolstarWebViewerState extends State<MolstarWebViewer> {
  InAppWebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  /// Build the asset URL, appending URL params if a PDB ID is given.
  String get _assetPath {
    const base =
        'file:///D:/MyBots/Works/FlutterProjects/Adv/ailixir/assets/web/viewer/index.html';
    if (widget.pdbId != null && widget.pdbId!.isNotEmpty) {
      return '$base?pdb=${widget.pdbId}&collapse-left-panel=1';
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── WebView ────────────────────────────────────────────────────────
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri('about:blank')),
          initialSettings: InAppWebViewSettings(
            // Allow WebGL / hardware acceleration
            allowsInlineMediaPlayback: true,
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: true,
            // Desktop-friendly settings
            supportZoom: false,
            disableHorizontalScroll: false,
            disableVerticalScroll: false,
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            // Allow same-origin local file reads (needed for molstar.js / .css)
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
          ),
          onWebViewCreated: (controller) async {
            _controller = controller;
            // Load the Mol* asset after the controller is ready
            await controller.loadUrl(
              urlRequest: URLRequest(url: WebUri(_assetPath)),
            );
          },
          onLoadStart: (_, __) {
            if (mounted) setState(() => _isLoading = true);
          },
          onLoadStop: (_, __) {
            if (mounted) setState(() => _isLoading = false);
          },
          onReceivedError: (_, __, ___) {
            if (mounted)
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
          },
          onConsoleMessage: (_, msg) {
            // Forward JS console output for debugging
            debugPrint('[MolStar JS] ${msg.message}');
          },
        ),

        // ── Loading overlay ─────────────────────────────────────────────────
        if (_isLoading)
          Container(
            color: AppColors.slate1000,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(AppColors.brandBlue),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Loading Mol* Viewer…',
                    style: AppTextStyles.bodysmall.copyWith(
                      color: AppColors.authTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ── Error overlay ───────────────────────────────────────────────────
        if (_hasError)
          Container(
            color: AppColors.slate1000,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: AppColors.authTextSecondary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Failed to load viewer',
                    style: AppTextStyles.bodysmall.copyWith(
                      color: AppColors.authTextSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextButton.icon(
                    onPressed: _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _reload() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    await _controller?.loadUrl(urlRequest: URLRequest(url: WebUri(_assetPath)));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
