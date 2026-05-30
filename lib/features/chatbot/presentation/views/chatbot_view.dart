import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/cubits/chat_session_cubit.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_sidebar.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatbotView extends StatelessWidget {
  static const String routeName = "/chatbot";
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatSessionCubit cubit = ChatSessionCubit();
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.assistant),
        backgroundColor: AppColors.slate1000,
      ),
      body: BlocProvider(
        create: (context) => cubit..getSessionThread(),
        child: Row(
          children: [
            Expanded(flex: 1, child: ChatbotSidebar()),
            Expanded(flex: 22, child: ChatbotViewBody(cubit: cubit)),
          ],
        ),
      ),
    );
  }
}
