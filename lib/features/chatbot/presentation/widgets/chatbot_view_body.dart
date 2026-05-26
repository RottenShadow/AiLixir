import 'package:ailixir/features/chatbot/presentation/widgets/chatbot_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotViewBody extends StatelessWidget {
  const ChatbotViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(right: 0.6.sw, left: 0.2.sw),
      child: Center(
        child: ChatbotTextbox(
          text:
              "Hello there bois and girls and pets. Hello there bois and girls and pets. Hello there bois and girls and pets. Hello there bois and girls and pet. Hello there bois and girls and pets. Hello there bois and girls and pets. Hello there bois and girls and petss",
        ),
      ),
    );
  }
}
