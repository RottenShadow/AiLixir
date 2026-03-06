import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:ailixir/features/auth/presentation/widgets/custom_auth_loading_overlay.dart';

import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/features/home/presentation/views/home_view.dart';
import '../widgets/join_view_body.dart';

class JoinView extends StatelessWidget {
  static const routeName = '/join';
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppToast.showErrorToast(context: context, message: state.msg);
          } else if (state is AuthSuccess) {
            AppToast.showSuccessToast(context: context, message: state.msg);
            context.navigateReplacementTo(HomeView.routeName);
          } else if (state is AuthShowToastState) {
            AppToast.showSuccessToast(context: context, message: state.msg);
          }
        },
        child: const CustomAuthLoadingOverlay(child: JoinViewBody()),
      ),
    );
  }
}
