import 'dart:ui';

import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/features/auth/presentation/widgets/auth_shared/auth_gradient_scaffold.dart';
import 'package:ailixir/features/chatbot/data/models/chat_message_model.dart';
import 'package:ailixir/features/chatbot/presentation/cubits/chat_session_cubit.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const int _animationDuration = 800;

class ChatbotViewBody extends StatefulWidget {
  final ChatSessionCubit cubit;
  const ChatbotViewBody({super.key, required this.cubit});
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
  late FocusNode _focusNode;
  void setWidgetPosition() {
    final RenderBox? box =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final Offset globalPosition = box.localToGlobal(Offset.zero);
      final double y = globalPosition.dy;
      final view = PlatformDispatcher.instance.views.first;
      final double screenHeight = view.physicalSize.height;
      final double distanceFromBottom =
          screenHeight - (y + box.size.height * 2);
      _textBoxHeight = distanceFromBottom + box.size.height - 5;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _textBoxHeight = 0;
    _padding = 200;
    _scrollController = ScrollController();
    _textcontroller = TextEditingController();
    _focusNode = FocusNode(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter &&
            !HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.shiftLeft,
            ) &&
            !HardwareKeyboard.instance.logicalKeysPressed.contains(
              LogicalKeyboardKey.shiftRight,
            )) {
          sendMessage();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );
  }

  void _addMessage(
    String text, {
    bool isBot = true,
    bool isErr = false,
    required void Function() onBufferFilled,
  }) {
    _messages.add(
      ChatbotTextbox(
        text: text,
        isError: isErr,
        isBot: isBot,
        onBufferFilled: onBufferFilled,
      ),
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
      await Future.delayed(Duration(milliseconds: _animationDuration + 50));
    }
    _addMessage(_textcontroller.text, isBot: false, onBufferFilled: () {});
    _sendingEnabled = false;
    _messages.add(ChatbotTextbox.loading());
    setState(() {});
    String message = _textcontroller.text.toString();
    _textcontroller.text = "";
    ChatMessageModel responseMessage = await widget.cubit.sendMessage(message);
    _messages.removeLast();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 50));
    widget.cubit.loading = true;
    _addMessage(
      responseMessage.message,
      isErr: responseMessage.isErr,
      onBufferFilled: () {
        _sendingEnabled = true;
        setState(() {});
        widget.cubit.loading = false;
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
      duration: Duration(milliseconds: _animationDuration),
      curve: Curves.easeInOutSine,
      child: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.brandBlue.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _textcontroller,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 3,
                        onSubmitted: (v) {},
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
    return AuthGradientScaffold(
      child: BlocBuilder<ChatSessionCubit, ChatSessionState>(
        builder: (context, state) {
          if (state is ChatSessionError) {
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 0.43.sh,
                horizontal: 0.35.sw,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.red700, width: 2),
                  borderRadius: BorderRadiusGeometry.circular(12.r),
                ),
                color: AppColors.red200,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Icon(Icons.error, color: AppColors.red700),
                      Text(
                        "Error: failed to fetch session",
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.red700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ChatSessionSuccess) {
            return Padding(
              padding: EdgeInsetsGeometry.only(right: 0.004.sw),
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
                            child: SafeArea(
                              child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 200,
                                ),
                                child: Column(children: _messages),
                              ),
                            ),
                          ),
                        ),
                        _promptTextField(),
                      ]
                    : [_promptTextField()],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  CircularProgressIndicator(color: AppColors.brandBlue),
                  Text("Fetching Chat Session", style: AppTextStyles.h5),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
