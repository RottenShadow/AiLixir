import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/core/widgets/buttons/custom_button.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_back_button.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_brand_logo.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    return AuthGradientScaffold(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 560.w,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.slate800.withValues(alpha: 0.95),
                      AppColors.slate900.withValues(alpha: 0.98),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: AppColors.brandBlue.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandBlue.withValues(alpha: 0.08),
                      blurRadius: 40,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthBackButton(
                      onTap: () {
                        context.pop();
                      },
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Change Account Details',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Update your profile information',
                      style: AppTextStyles.bodymedium.copyWith(
                        color: AppColors.authTextSecondary,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    CustomTextFormField(
                      label: 'Name',
                      hint: "",
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.slate400,
                        size: 18.sp,
                      ),
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(height: 36.h),
                    CustomButton(
                      text: 'Update Details',
                      isLoading: isLoading,
                      icon: Icons.person_outlined,
                      showIcon: true,
                      width: double.infinity,
                      onTap: () async {
                        isLoading = true;
                        var res = await widget.repo.updateProfile(
                          _nameController.text,
                          _instituteController.text,
                          _focusController.text,
                        );
                        isLoading = false;
                        res.fold(
                          (f) {
                            AppToast.showErrorToast(
                              context: context,
                              message: "Failed to Update Profile",
                            );
                          },
                          (success) {
                            if (success) {
                              context.pop();
                            } else {
                              AppToast.showErrorToast(
                                context: context,
                                message: "Failed to Update Profile",
                              );
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                '© 2026 AILIXIR PLATFORM.',
                style: AppTextStyles.labelsmall.copyWith(
                  color: AppColors.authTextSecondary.withValues(alpha: 0.5),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
