import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/profile/presentation/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brandBlue.withOpacity(0.01),
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ProfileViewBody(),
    );
  }
}
