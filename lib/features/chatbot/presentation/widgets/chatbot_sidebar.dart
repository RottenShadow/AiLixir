import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/cubits/chat_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatbotSidebar extends StatelessWidget {
  final ChatSessionCubit cubit;
  const ChatbotSidebar({super.key, required this.cubit});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: AppColors.slate1000),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                if (!cubit.loading) {
                  context.pop();
                }
              },
              tooltip: "Return to Home",
              icon: Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: () {},
              tooltip: "Search Messages",
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              tooltip: "Conversations",
              icon: Icon(Icons.chat),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              tooltip: "Settings",
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
