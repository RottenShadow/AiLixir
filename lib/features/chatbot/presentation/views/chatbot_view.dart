import 'package:ailixir/features/chatbot/presentation/cubits/chat_session_cubit.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_sidebar.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatbotView extends StatefulWidget {
  static const String routeName = "/chatbot";
  const ChatbotView({super.key});

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  late final ChatSessionCubit _cubit;
  bool _isSidebarExpanded = false;

  @override
  void initState() {
    super.initState();
    _cubit = ChatSessionCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _cubit..getSessionThread(),
        child: Row(
          children: [
            ChatbotSidebar(
              isExpanded: true,
              cubit: _cubit,
              onOpen: () => setState(() => _isSidebarExpanded = true),
              onClose: () => setState(() => _isSidebarExpanded = false),
              onExit: () => Navigator.maybePop(context),
            ),
            Expanded(flex: 22, child: ChatbotViewBody(cubit: _cubit)),
          ],
        ),
      ),
    );
  }
}

//class ChatbotView extends StatelessWidget {
//  static const String routeName = "/chatbot";
//  const ChatbotView({super.key});
//
//  @override
//  Widget build(BuildContext context) {
//    final ChatSessionCubit cubit = ChatSessionCubit();
//    return Scaffold(
//      body: BlocProvider(
//        create: (context) => cubit..getSessionThread(),
//        child: Row(
//          children: [
//            Expanded(flex: 1, child: ChatbotSidebar(cubit: cubit)),
//            Expanded(flex: 22, child: ChatbotViewBody(cubit: cubit)),
//          ],
//        ),
//      ),
//    );
//  }
//}
