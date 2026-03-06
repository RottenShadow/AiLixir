import 'package:flutter/material.dart';
import 'package:ailixir/core/services/navigation/app_router.dart';

/// Global navigation service for deep link and notification handling
/// Uses a global navigator key to navigate from anywhere in the app
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Global navigator key - set in MaterialApp
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Current navigator state
  NavigatorState? get navigator => navigatorKey.currentState;

  /// Current context
  BuildContext? get context => navigatorKey.currentContext;
}

extension NavigationExtension on BuildContext {
  /// Navigate to a named route
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return AppRouter.router.push<T>(routeName, extra: arguments);
  }

  /// Navigate and replace current route
  Future<T?> navigateReplacementTo<T>(String routeName, {Object? arguments}) {
    return AppRouter.router.replace<T>(routeName, extra: arguments);
  }

  /// Navigate and clear all previous routes
  void navigateAndClearStack(String routeName, {Object? arguments}) {
    AppRouter.router.go(routeName, extra: arguments);
  }

  /// Pop the current route
  void goBack<T>({T? result}) {
    if (AppRouter.router.canPop()) {
      AppRouter.router.pop(result);
    }
  }

  /// Pop until a specific route name
  void popUntil(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }

  /// Check if we can pop
  bool canPop() {
    return AppRouter.router.canPop();
  }
}
