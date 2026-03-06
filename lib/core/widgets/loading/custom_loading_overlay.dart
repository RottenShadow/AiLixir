import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ailixir/core/widgets/loading/custom_circular_progress_indicator.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const CustomLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CustomCircularProgressIndicator(),
      inAsyncCall: isLoading,
      child: child,
    );
  }
}
