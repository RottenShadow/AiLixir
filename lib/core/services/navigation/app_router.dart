import 'package:ailixir/features/awards/data/models/award_package.dart';
import 'package:ailixir/features/awards/presentation/views/awards_view.dart';
import 'package:ailixir/features/awards/presentation/views/single_award_view.dart';
import 'package:ailixir/features/chatbot/presentation/views/chatbot_view.dart';
import 'package:ailixir/features/main/presentation/views/main_view.dart';
import 'package:ailixir/features/profile/presentation/views/profile_view.dart';
import 'package:ailixir/features/scientists/data/models/scientist_package.dart';
import 'package:ailixir/features/scientists/presentation/views/scientist_credits_view.dart';
import 'package:ailixir/features/scientists/presentation/views/single_scientist_view.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/widgets/custom_photo_view.dart';
import 'package:ailixir/features/auth/presentation/views/forgot_password_view.dart';
import 'package:ailixir/features/auth/presentation/views/join_view.dart';
import 'package:ailixir/features/auth/presentation/views/login_view.dart';
import 'package:ailixir/features/auth/presentation/views/reset_password_otp_view.dart';
import 'package:ailixir/features/auth/presentation/views/signup_view.dart';
import 'package:ailixir/features/auth/presentation/views/verify_email_view.dart';
import 'package:ailixir/features/history/presentation/views/ligand_details_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ailixir/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService().navigatorKey,
    initialLocation: SplashView.routeName,
    routes: [
      GoRoute(
        path: SplashView.routeName,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: MainView.routeName,
        builder: (context, state) => const MainView(),
      ),

      // ── Auth ──────────────────────────────────────────────────────────────
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
      GoRoute(
        path: VerifyEmailView.routeName,
        builder: (context, state) =>
            VerifyEmailView(email: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: ForgotPasswordView.routeName,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: ResetPasswordOtpView.routeName,
        builder: (context, state) =>
            ResetPasswordOtpView(email: state.extra as String? ?? ''),
      ),

      // ── Scientists & Awards ────────────────────────────────────────────
      GoRoute(
        path: ScientistCreditView.routeName,
        builder: (context, state) => const ScientistCreditView(),
      ),
      GoRoute(
        path: AwardsView.routeName,
        builder: (context, state) => AwardsView(query: state.extra as String),
      ),
      GoRoute(
        path: SingleScientistView.routeName,
        builder: (context, state) =>
            SingleScientistView(package: state.extra as ScientistPackage),
      ),
      // Profile
      GoRoute(
        path: ProfileView.routeName,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: ChatbotView.routeName,
        builder: (context, state) => const ChatbotView(),
      ),
      GoRoute(
        path: SingleAwardView.routeName,
        builder: (context, state) {
          AwardPackage pkg = state.extra as AwardPackage;
          return SingleAwardView(award: pkg.award, cubit: pkg.cubit);
        },
      ),

      // ── Ligand Details ──────────────────────────────────────────────
      GoRoute(
        path: LigandDetailsView.routeName,
        builder: (context, state) =>
            LigandDetailsView(ligand: state.extra as LigandEntity),
      ),

      // ── Misc ──────────────────────────────────────────────────────────────
      GoRoute(
        path: CustomPhotoView.routeName,
        builder: (context, state) =>
            CustomPhotoView(imageUrl: state.extra as String),
      ),
    ],
  );
}
