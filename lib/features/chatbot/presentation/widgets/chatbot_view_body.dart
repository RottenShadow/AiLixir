import 'dart:io';

import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotViewBody extends StatefulWidget {
  const ChatbotViewBody({super.key});
  @override
  State<StatefulWidget> createState() => _ChatbotViewBodyState();
}

class _ChatbotViewBodyState extends State<ChatbotViewBody> {
  late final TextEditingController _textcontroller;
  late final ScrollController _scrollController;
  final List<ChatbotTextbox> _messages = [];
  bool _sendingEnabled = true;
  late double _textBoxHeight;
  late double _padding;
  final GlobalKey _widgetKey = GlobalKey();
  final _focusNode = FocusNode();

  void setWidgetPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
          _widgetKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final Offset globalPosition = box.localToGlobal(Offset.zero);
        final double y = globalPosition.dy;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double distanceFromBottom = screenHeight - (y + box.size.height);
        _textBoxHeight = distanceFromBottom + box.size.height * 1.8;
        _padding = 0;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _textBoxHeight = 0;
    _padding = 200;
    _scrollController = ScrollController();
    _textcontroller = TextEditingController();
  }

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

  Future<void> sendMessage() async {
    if (_textcontroller.text == "") {
      return;
    }
    if (_messages.isEmpty) {
      setWidgetPosition();
      await Future.delayed(Duration(milliseconds: 450));
    }
    _addMessage(_textcontroller.text, isBot: false, onBufferFilled: () {});
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
  }

  Widget _promptTextField() {
    return AnimatedContainer(
      key: _widgetKey,
      padding: EdgeInsetsGeometry.only(
        top: _messages.isEmpty ? _textBoxHeight : 0,
        left: _padding,
        right: _padding,
      ),
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white.withAlpha(90),
                  offset: const Offset(0, -2),
                  blurRadius: 0.1,
                  spreadRadius: 0.08,
                ),
                BoxShadow(
                  color: AppColors.black.withAlpha(155),
                  offset: const Offset(0, 2),
                  blurRadius: 5.0,
                  spreadRadius: 0.9,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      KeyboardListener(
                        focusNode: _focusNode,
                        onKeyEvent: (event) {},
                        child: TextField(
                          controller: _textcontroller,
                          minLines: 1,
                          maxLines: 3,
                          enabled: _sendingEnabled,
                          decoration: InputDecoration(
                            hintText: "Ask Something...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              sendMessage();
                            },
                            icon: Icon(Icons.send),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(right: 0.02.sw),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: _messages.isNotEmpty
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: _messages.isNotEmpty
            ? [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: _messages),
                  ),
                ),
                _promptTextField(),
              ]
            : [_promptTextField()],
      ),
    );
  }
}
