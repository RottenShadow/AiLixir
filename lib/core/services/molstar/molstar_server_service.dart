import 'dart:developer';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MolstarServerService {
  static final MolstarServerService _instance =
      MolstarServerService._internal();
  factory MolstarServerService() => _instance;
  MolstarServerService._internal();

  InAppLocalhostServer? _server;

  Future<void> start() async {
    if (_server != null && _server!.isRunning()) {
      log('[MolstarServer] Server is already running');
      return;
    }

    try {
      _server = InAppLocalhostServer(documentRoot: 'assets/web', port: 8080);
      await _server!.start();
      log('[MolstarServer] Local server started on http://localhost:8080');
    } catch (e) {
      log('[MolstarServer] Error starting local server: $e');
    }
  }

  Future<void> stop() async {
    if (_server != null && _server!.isRunning()) {
      await _server!.close();
      _server = null;
      log('[MolstarServer] Local server stopped');
    }
  }
}
