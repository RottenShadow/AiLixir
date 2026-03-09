import 'package:ailixir/features/awards/presentation/views/awards_view.dart';
import 'package:ailixir/features/main/presentation/views/main_view.dart';
import 'package:ailixir/features/scientists/presentation/views/scientist_credits_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/widgets/custom_photo_view.dart';
import 'package:ailixir/features/auth/presentation/views/join_view.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/features/auth/presentation/views/signup_view.dart';
import 'package:ailixir/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService().navigatorKey,
    initialLocation: SplashView.routeName,
    routes: [
      // Home
      GoRoute(
        path: MainView.routeName,
        builder: (context, state) => const MainView(),
      ),
      // Scientist Credits
      GoRoute(
        path: ScientistCreditView.routeName,
        builder: (context, state) => const ScientistCreditView(),
      ),
      // Awards
      GoRoute(
        path: AwardsView.routeName,
        builder: (context, state) {
          return AwardsView(query: state.extra as String);
        },
      ),
      // Splash & Onboarding
      GoRoute(
        path: SplashView.routeName,
        builder: (context, state) => const SplashView(),
      ),

      // Auth
      GoRoute(
        path: JoinView.routeName,
        builder: (context, state) => const JoinView(),
      ),
      GoRoute(
        path: LoginView.routeName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: SignupView.routeName,
        builder: (context, state) => const SignupView(),
      ),

      // Photo View
      GoRoute(
        path: CustomPhotoView.routeName,
        builder: (context, state) {
          final imageUrl = state.extra as String;
          return CustomPhotoView(imageUrl: imageUrl);
        },
      ),
    ],
  );
}
