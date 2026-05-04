import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/services/molstar_server_service.dart';

/// Called when the JS side reports a clamped box update.
typedef BoxCenterCallback = void Function(
    double cx, double cy, double cz, [double? sx, double? sy, double? sz]);

/// Mol* viewer for the docking screen.
class DockingMolstarViewer extends StatefulWidget {
  /// Fired whenever JS reports a new box center (atom click or auto-center).
  final BoxCenterCallback? onBoxCenterChanged;

  const DockingMolstarViewer({super.key, this.onBoxCenterChanged});

  @override
  State<DockingMolstarViewer> createState() => DockingMolstarViewerState();
}

class DockingMolstarViewerState extends State<DockingMolstarViewer> {
  InAppWebViewController? _ctrl;
  bool _loading = true;
  bool _ready = false;

  Timer? _readyPoller;
  final List<String> _jsQueue = [];

  @override
  void initState() {
    super.initState();
    MolstarServerService().start();
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  Future<void> loadProteinText(String rawText, String format) async {
    final b64 = base64Encode(utf8.encode(rawText));
    await _eval("loadStructureBase64('$b64', '$format')");
  }

  Future<void> loadLigandText(String rawText, String format) async {
    final b64 = base64Encode(utf8.encode(rawText));
    await _eval("loadLigandBase64('$b64', '$format')");
  }

  Future<void> loadStructureBase64(String b64, String format) async {
    await _eval("loadStructureBase64('$b64', '$format')");
  }

  Future<void> loadLigandBase64(String b64, String format) async {
    await _eval("loadLigandBase64('$b64', '$format')");
  }

  Future<void> updateBox({
    required double cx,
    required double cy,
    required double cz,
    required double sx,
    required double sy,
    required double sz,
  }) async {
    await _eval('updateBox($cx,$cy,$cz,$sx,$sy,$sz)');
  }

  Future<void> clearAll() async => _eval('clearAll()');
  Future<void> clearProtein() async => _eval('clearProtein()');
  Future<void> clearLigand() async => _eval('clearLigand()');

  // ── Internal ────────────────────────────────────────────────────────────────

  Future<void> _eval(String js) async {
    if (_ctrl == null || !_ready) {
      _jsQueue.add(js);
      return;
    }
    try {
      await _ctrl!.evaluateJavascript(source: js);
    } catch (e) {
      debugPrint('[DockingViewer] JS error: $e');
    }
  }

  Future<void> _processQueue() async {
    while (_jsQueue.isNotEmpty) {
      final js = _jsQueue.removeAt(0);
      try {
        await _ctrl?.evaluateJavascript(source: js);
      } catch (e) {
        debugPrint('[DockingViewer] Queue error: $e');
      }
    }
  }

  void _startReadyPoller() {
    _readyPoller?.cancel();
    _readyPoller = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      if (!mounted || _ctrl == null) return;
      try {
        final result = await _ctrl!.evaluateJavascript(
          source: 'window._viewerReady === true',
        );
        if (result == true || result == 'true') {
          _readyPoller?.cancel();
          if (mounted) {
            setState(() => _ready = true);
            _processQueue();
          }
          debugPrint('[DockingViewer] Mol* viewer ready.');
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _readyPoller?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri('http://localhost:8080/docker_index.html'),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            domStorageEnabled: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            transparentBackground: false,
            mediaPlaybackRequiresUserGesture: false,
            supportZoom: false,
            useWideViewPort: true,
            loadWithOverviewMode: true,
            safeBrowsingEnabled: false,
            javaScriptCanOpenWindowsAutomatically: true,
            databaseEnabled: true,
            cacheEnabled: true,
          ),
          onWebViewCreated: (c) {
            _ctrl = c;
            // Register the handler BEFORE the page loads so JS can call it.
            c.addJavaScriptHandler(
              handlerName: 'onBoxCenterChanged',
              callback: (args) {
                if (args.isEmpty) return;
                try {
                  final data = args[0] as Map<dynamic, dynamic>;
                  final cx = (data['cx'] as num).toDouble();
                  final cy = (data['cy'] as num).toDouble();
                  final cz = (data['cz'] as num).toDouble();
                  final sx = data['sx'] != null ? (data['sx'] as num).toDouble() : null;
                  final sy = data['sy'] != null ? (data['sy'] as num).toDouble() : null;
                  final sz = data['sz'] != null ? (data['sz'] as num).toDouble() : null;
                  widget.onBoxCenterChanged?.call(cx, cy, cz, sx, sy, sz);
                } catch (e) {
                  debugPrint(
                    '[DockingViewer] onBoxCenterChanged parse error: $e',
                  );
                }
              },
            );
          },
          onLoadStop: (_, __) {
            if (mounted) setState(() => _loading = false);
            _startReadyPoller();
          },
          onConsoleMessage: (_, m) => debugPrint('[DockingJS] ${m.message}'),
        ),
        if (_loading)
          Container(
            color: AppColors.slate1000,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36.w,
                    height: 36.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.cyan400,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Loading docking viewer...',
                    style: AppTextStyles.bodysmall.copyWith(
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
