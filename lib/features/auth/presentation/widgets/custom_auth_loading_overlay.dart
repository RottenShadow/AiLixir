import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ailixir/core/widgets/loading/custom_loading_overlay.dart';
import 'package:ailixir/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';

class CustomAuthLoadingOverlay extends StatelessWidget {
  final Widget child;
  const CustomAuthLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomLoadingOverlay(
      isLoading: context.watch<AuthCubit>().state is AuthLoading,
      child: child,
    );
  }
}
