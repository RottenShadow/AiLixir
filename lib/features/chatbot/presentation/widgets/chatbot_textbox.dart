import 'package:ailixir/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

const String _indicator = "_";
const Duration _waitDuration = Duration(milliseconds: 150);
const Radius _messageRadius = Radius.circular(20);

class ChatbotTextbox extends StatefulWidget {
  const ChatbotTextbox._construct({super.key, required this.text});
  ChatbotTextbox({Key? key, required String text})
    : this._construct(key: key, text: text.split(" "));
  final List<String> text;
  @override
  State<StatefulWidget> createState() => _ChatbotTextbox();
}

class _ChatbotTextbox extends State<ChatbotTextbox> {
  String _buffer = "";
  int _textptr = 0;
  Future<void> fillBuffer() async {
    if (_textptr >= widget.text.length) {
      return;
    }
    await Future.delayed(_waitDuration);
    setState(() {
      _buffer += _indicator;
    });
    await Future.delayed(_waitDuration);
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
    fillBuffer();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topRight: _messageRadius,
          bottomRight: _messageRadius,
          bottomLeft: _messageRadius,
        ),
      ),
      color: AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Text(_buffer, softWrap: true),
      ),
    );
  }
}
