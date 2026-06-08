import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/profile/data/models/profile_model.dart';
import 'package:ailixir/features/profile/data/repos/profile_repo.dart';
import 'package:ailixir/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileViewBody extends StatefulWidget {
  final ProfileModel profile;
  final ProfileRepo repo;
  const UpdateProfileViewBody({
    super.key,
    required this.profile,
    required this.repo,
  });
  @override
  State<StatefulWidget> createState() => _UpdateProfileViewBodyState();
}

class _UpdateProfileViewBodyState extends State<UpdateProfileViewBody> {
  late TextEditingController _nameController;
  late TextEditingController _instituteController;
  late TextEditingController _focusController;
  late bool isErr;
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _instituteController = TextEditingController(
      text: widget.profile.institution,
    );
    _focusController = TextEditingController(text: widget.profile.focus);
    isErr = false;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: 0.02.sh,
        horizontal: 0.28.sw,
      ),
      child: Center(
        child: Card(
          color: AppColors.cardBackground,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 40,
              children: [
                Row(
                  children: [
                    Text(
                      "Please change the fields to your liking and submit.",
                      style: AppTextStyles.caption,
                    ),
                    Spacer(),
                    Icon(Icons.person),
                  ],
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
                TextField(
                  controller: _instituteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Institution",
                  ),
                ),
                TextField(
                  controller: _focusController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Research Focus",
                  ),
                ),
                Visibility(
                  visible: isErr,
                  replacement: SizedBox(),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.error, color: AppColors.red600),
                      Text(
                        "Failed to update profile. Please try again.",
                        style: AppTextStyles.labelmedium.copyWith(
                          color: AppColors.red600,
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12.r),
                  ),
                  onPressed: () async {
                    isLoading = true;
                    setState(() {});
                    var res = await widget.repo.updateProfile(
                      _nameController.text,
                      _instituteController.text,
                      _focusController.text,
                    );

                    res.fold(
                      (e) {
                        isLoading = false;
                        setState(() {
                          isErr = true;
                        });
                      },
                      (v) {
                        isLoading = false;
                        if (v) {
                          context.pop();
                        } else {
                          isErr = true;
                          setState(() {});
                        }
                      },
                    );
                  },
                  color: AppColors.brandBlue,
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
