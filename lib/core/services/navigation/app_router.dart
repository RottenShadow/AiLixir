import 'package:ailixir/features/awards/data/models/award_package.dart';
import 'package:ailixir/features/awards/presentation/views/awards_view.dart';
import 'package:ailixir/features/awards/presentation/views/single_award_view.dart';
import 'package:ailixir/features/main/presentation/views/main_view.dart';
import 'package:ailixir/features/profile/presentation/views/profile_view.dart';
import 'package:ailixir/features/scientists/data/models/scientist_model.dart';
import 'package:ailixir/features/scientists/data/models/scientist_package.dart';
import 'package:ailixir/features/scientists/presentation/views/scientist_credits_view.dart';
import 'package:ailixir/features/scientists/presentation/views/single_scientist_view.dart';
import 'package:ailixir/features/similarity/presentation/views/similarity_result_view.dart';
import 'package:ailixir/features/awards/presentation/views/awards_view.dart';
import 'package:ailixir/core/entities/ligand_entity.dart';
import 'package:ailixir/features/history/presentation/views/ligand_details_view.dart';
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
      // Awards
      GoRoute(
        path: AwardsView.routeName,
        builder: (context, state) {
          return AwardsView(query: state.extra as String);
        },
      ),
      GoRoute(
        path: SingleAwardView.routeName,
        builder: (context, state) {
          AwardPackage pkg = state.extra as AwardPackage;
          return SingleAwardView(award: pkg.award, cubit: pkg.cubit);
        },
      ),
      GoRoute(
        path: SimilarityResultView.routeName,
        builder: (context, state) {
          return SimilarityResultView(smileQuery: state.extra as String);
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

      // Ligand Details
      GoRoute(
        path: LigandDetailsView.routeName,
        builder: (context, state) {
          final ligand = state.extra as LigandEntity;
          return LigandDetailsView(ligand: ligand);
        },
      ),
    ],
  );
}
