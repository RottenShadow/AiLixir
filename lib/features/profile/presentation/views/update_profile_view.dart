import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/profile/data/models/profile_model.dart';
import 'package:ailixir/features/profile/data/repos/profile_repo.dart';
import 'package:ailixir/features/profile/presentation/widgets/update_profile_view_body.dart';
import 'package:flutter/material.dart';

class UpdateProfileView extends StatelessWidget {
  static const String routeName = "/updateprofile";
  final ProfileRepo repo;
  final ProfileModel profile;
  const UpdateProfileView({
    super.key,
    required this.profile,
    required this.repo,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpdateProfileViewBody(repo: repo, profile: profile),
    );
  }
}
