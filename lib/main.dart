import 'dart:developer';

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/app.dart';
import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/utils/cubit_observer.dart';
import 'package:ailixir/core/services/di/get_it.dart';
import 'package:ailixir/core/services/local_storage/secure_storage_service.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register singletons
  getItRegisterSingleton();

  // Initialize core services
  await Future.wait([
    SharedPreferencesService.init(),
    dotenv.load(fileName: ".env"),
    // Initialize firebase service
    // _initializeBackgroundServices(),
  ]);

  log(
    'test Token: ${await GetIt.I.get<SecureStorageService>().readValue(key: AppConstants.accessTokenKey)}',
  );
  // log(
  //   'test Refresh Token: ${await GetIt.I.get<SecureStorageService>().readValue(key: AppConstants.refreshAccessTokenKey)}',
  // );
  Bloc.observer = CubitObserver();

  runApp(const AilixirApp());
}

// Future<void> _initializeBackgroundServices() async {
//   try {
//     await Firebase.initializeApp();
//     log('[Firebase Core] Firebase core initialized');
//   } catch (e, st) {
//     log('[Firebase Core] Error initializing firebase core: $e\n$st');
//   }
// }
