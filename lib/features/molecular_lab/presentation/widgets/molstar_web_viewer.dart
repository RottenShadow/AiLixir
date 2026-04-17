import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import '../cubits/molecular_lab_cubit.dart';

/// A WebView widget that loads the bundled Mol* (MolStar) molecular viewer
/// from the local Flutter asset `assets/web/index.html`.
///
/// It initializes the WebView ONLY ONCE and listens to [MolecularLabCubit]
/// to load new structures without disposing/recreating the view.
class MolstarWebViewer extends StatefulWidget {
  const MolstarWebViewer({super.key});

  @override
  State<MolstarWebViewer> createState() => _MolstarWebViewerState();
}

class _MolstarWebViewerState extends State<MolstarWebViewer> {
  InAppWebViewController? _controller;
  bool _isWebViewReady = false;
  bool _isLoading = true;
  bool _hasError = false;

  static const String _baseAssetPath = 'http://localhost:8080/index.html';

  /// Helper to build the full asset URL with parameters
  String _getTargetUrl(String? pdbId) {
    if (pdbId != null && pdbId.isNotEmpty) {
      return '$_baseAssetPath?pdb=$pdbId&collapse-left-panel=1';
    }
    return '$_baseAssetPath?collapse-left-panel=1';
  }

  /// Loads a specific PDB into the existing WebView
  Future<void> _loadStructure(String pdbId) async {
    if (_controller == null) return;

    if (mounted) setState(() => _isLoading = true);

    try {
      await _controller!.loadUrl(
        urlRequest: URLRequest(url: WebUri(_getTargetUrl(pdbId))),
      );
    } catch (e) {
      debugPrint('Error loading PDB: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MolecularLabCubit, MolecularLabState>(
      listener: (context, state) {
        if (state is MolecularLabLoaded && _isWebViewReady) {
          _loadStructure(state.pdbId);
        }
      },
      child: Stack(
        children: [
          // ── WebView (Initialized Only Once) ────────────────────────────────
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(_baseAssetPath)),
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
              useWideViewPort: true,
              loadWithOverviewMode: true,
            ),
            onWebViewCreated: (controller) async {
              _controller = controller;
              _isWebViewReady = true;

              // // If we already have a PDB in state, load it immediately
              // final currentState = context.read<MolecularLabCubit>().state;
              // String targetPath = _baseAssetPath;
              // if (currentState is MolecularLabLoaded) {
              //   targetPath = _getTargetUrl(currentState.pdbId);
              //   // await controller.loadUrl(
              //   //   urlRequest: URLRequest(url: WebUri(targetPath)),
              //   // );
              // }
            },
            onLoadStart: (_, __) {
              if (mounted) setState(() => _isLoading = true);
            },
            onLoadStop: (_, __) {
              if (mounted) setState(() => _isLoading = false);
            },
            onReceivedError: (_, __, error) {
              if (error.description.contains('stopped') ||
                  error.description.contains('interrupted')) {
                return;
              }

              debugPrint('WebView Error: ${error.description}');
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              }
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
                      'Analyzing structure...',
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
                      'Failed to load molecular data',
                      style: AppTextStyles.bodysmall.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextButton.icon(
                      onPressed: () async {
                        final state = context.read<MolecularLabCubit>().state;
                        if (state is MolecularLabLoaded) {
                          _loadStructure(state.pdbId);
                        } else {
                          await _controller?.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri(_getTargetUrl(null)),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
