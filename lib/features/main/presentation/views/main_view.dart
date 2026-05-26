import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/views/chatbot_view.dart';
import 'package:flutter/material.dart';
import '../widgets/main_view_body.dart';

class MainView extends StatelessWidget {
  static const routeName = '/main';
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColors.brandBlue,
        onPressed: () {
          context.navigateTo(ChatbotView.routeName);
        },
        child: Icon(Icons.assistant),
      ),
      body: MainViewBody(),
    );
  }
}
