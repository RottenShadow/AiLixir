import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotViewBody extends StatefulWidget {
  const ChatbotViewBody({super.key});
  @override
  State<StatefulWidget> createState() => _ChatbotViewBodyState();
}

class _ChatbotViewBodyState extends State<ChatbotViewBody> {
  final TextEditingController _textcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatbotTextbox> _messages = [];
  bool _sendingEnabled = true;

  void _addMessage(
    String text, {
    bool isBot = true,
    required void Function() onBufferFilled,
  }) {
    _messages.add(
      ChatbotTextbox(text: text, isBot: isBot, onBufferFilled: onBufferFilled),
    );
    setState(() {});
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _promptTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: AppColors.cardBackground,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textcontroller,
                minLines: 1,
                maxLines: 3,
                enabled: _sendingEnabled,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      _addMessage(
                        _textcontroller.text,
                        isBot: false,
                        onBufferFilled: () {},
                      );
                      _textcontroller.text = "";
                      _sendingEnabled = false;
                      await Future.delayed(Duration(milliseconds: 600));
                      _addMessage(
                        "Not Implemented Yet, Not Implemented Yet Not Implemented Yet Not Implemented Yet Not Implemented Yet",
                        onBufferFilled: () {
                          _sendingEnabled = true;
                          setState(() {});
                        },
                      );
                      setState(() {});
                    },
                    icon: Icon(Icons.send),
                  ),
                  hintText: "Ask Something...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.brandBlue.withAlpha(155),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 0.1.sw),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: _messages),
            ),
          ),
          _promptTextField(),
        ],
      ),
    );
  }
}
