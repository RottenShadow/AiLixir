import 'package:flutter/material.dart';
import '../widgets/main_view_body.dart';

class MainView extends StatelessWidget {
  static const routeName = '/main';
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MainViewBody());
  }
}
