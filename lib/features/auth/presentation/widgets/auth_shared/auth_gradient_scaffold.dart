import 'package:ailixir/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Full-screen gradient background scaffold shared by all auth screens.
/// Import this file to get [AuthGradientScaffold].
class AuthGradientScaffold extends StatelessWidget {
  final Widget child;
  const AuthGradientScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0F1E), // deep navy
              Color(0xFF0E1424), // slate1000
              Color(0xFF0D1B2A), // dark teal-navy
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Ambient glow — top right
            Positioned(
              top: -120,
              right: -120,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandBlue.withValues(alpha: 0.06),
                ),
              ),
            ),
            // Ambient glow — bottom left
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.logoGradientMid.withValues(alpha: 0.04),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
