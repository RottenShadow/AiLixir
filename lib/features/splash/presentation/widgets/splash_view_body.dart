import 'package:ailixir/features/main/presentation/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ailixir/core/constants/app_constants.dart';
import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/services/local_storage/shared_preferences_service.dart';
import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/features/auth/data/data_source/local_auth_data_source.dart';
import 'package:ailixir/features/auth/presentation/views/join_view.dart';

import 'package:ailixir/core/themes/app_colors.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true); // Subtle breathing effect

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    performNavigation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF263045), // Lighter focal center
            AppColors.brandBorder, // Dark brand border color (#1E2430)
          ],
          center: Alignment.center,
          radius: 1.0,
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandBlue.withOpacity(0.05),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Image.asset(AppImages.logo, fit: BoxFit.contain),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void performNavigation() async {
    // Reveal timing
    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (mounted) {
        // var isOnbaored = SharedPreferencesService.getBool(
        //   key: AppConstants.isOnboardedKey,
        // );
        String? userAccessToken = await GetIt.I<LocalAuthDataSource>()
            .getUserToken();

        // if (!isOnbaored) {
        //   // return context.navigateReplacementTo(OnboardingView.routeName);
        //   // Replace when adding onboarding view
        //   return context.navigateReplacementTo(JoinView.routeName);
        // }
        if (userAccessToken?.isNotEmpty ?? false) {
          return context.navigateReplacementTo(MainView.routeName);
          // Replace when adding main view
          // return context.navigateReplacementTo(JoinView.routeName);
        }
        return context.navigateReplacementTo(JoinView.routeName);
      }
    });
  }
}
