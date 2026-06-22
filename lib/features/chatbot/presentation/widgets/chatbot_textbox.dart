import 'dart:io';

import 'package:ailixir/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const String _indicator = "_";
const Duration _waitDuration = Duration(milliseconds: 150);
const Radius _messageRadius = Radius.circular(20);
const botRadius = BorderRadiusGeometry.only(
  topRight: _messageRadius,
  bottomRight: _messageRadius,
  bottomLeft: _messageRadius,
);

const userRadius = BorderRadiusGeometry.only(
  topLeft: _messageRadius,
  bottomRight: _messageRadius,
  bottomLeft: _messageRadius,
);

void _nop() {}

class ChatbotTextbox extends StatefulWidget {
  const ChatbotTextbox._construct({
    super.key,
    required this.text,
    required this.isBot,
    required this.onBufferFilled,
    required this.isError,
    required this.isLoading,
  });
  ChatbotTextbox({
    Key? key,
    required String text,
    bool isBot = true,
    bool isError = false,
    bool isLoading = false,
    void Function() onBufferFilled = _nop,
  }) : this._construct(
         key: key,
         text: text.split(" "),
         isBot: isBot,
         onBufferFilled: onBufferFilled,
         isError: isError,
         isLoading: isLoading,
       );
  ChatbotTextbox.loading() : this(text: ". . . .", isLoading: true);
  final List<String> text;
  final bool isBot;
  final bool isError;
  final void Function() onBufferFilled;
  final bool isLoading;
  @override
  State<StatefulWidget> createState() => _ChatbotTextbox();
}

class _ChatbotTextbox extends State<ChatbotTextbox> {
  String _buffer = "";
  int _textptr = 0;
  bool _killed = false;
  static final double _widthPadding = 0.3.sw;
  Future<void> fillBuffer() async {
    if (_textptr >= widget.text.length) {
      if (widget.isLoading) {
        _textptr = 0;
        _buffer = ". ";
        return fillBuffer();
      }
      widget.onBufferFilled();
      return;
    }
    await Future.delayed(_waitDuration);
    if (_killed) return;
    setState(() {
      _buffer += _indicator;
    });
    await Future.delayed(_waitDuration);
    if (_killed) return;
    setState(() {
      _buffer = _buffer.replaceFirst(_indicator, "");
      _buffer += widget.text[_textptr];
      _buffer += " ";
      _textptr += 1;
    });
    return fillBuffer();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isBot) {
      fillBuffer();
    } else {
      _buffer = widget.text.join(" ");
    }
  }

  @override
  void dispose() {
    _killed = true;
    sleep(Duration(milliseconds: 200));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        left: widget.isBot ? 0 : _widthPadding,
        right: widget.isBot ? _widthPadding : 0,
        bottom: 20,
      ),
      child: Align(
        alignment: widget.isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: widget.isBot ? botRadius : userRadius,
          ),
          color: widget.isBot
              ? AppColors.cardBackground
              : AppColors.brandBlue.withAlpha(155),
          child: Padding(
            padding: EdgeInsetsGeometry.all(12),
            child: SelectableText(
              _buffer,
              style: widget.isError ? TextStyle(color: AppColors.red500) : null,
            ),
          ),
        ),
      ),
    );
  }
}
