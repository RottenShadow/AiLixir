import 'package:ailixir/features/scientists/presentation/widgets/scientist_credits_view_body.dart';
import 'package:flutter/material.dart';

class ScientistCreditView extends StatelessWidget {
  static const routeName = '/credits';
  const ScientistCreditView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ScientistCreditsViewBody());
  }
}
