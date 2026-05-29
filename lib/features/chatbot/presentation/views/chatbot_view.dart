import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_sidebar.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_view_body.dart';
import 'package:flutter/material.dart';

class ChatbotView extends StatelessWidget {
  static const String routeName = "/chatbot";
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.assistant),
        backgroundColor: AppColors.slate1000,
      ),
      body: Row(
        children: [
          Expanded(flex: 1, child: ChatbotSidebar()),
          Expanded(flex: 22, child: ChatbotViewBody()),
        ],
      ),
    );
  }
}
