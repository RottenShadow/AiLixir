import 'package:ailixir/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotSidebar extends StatelessWidget {
  const ChatbotSidebar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate1000,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
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
    );
  }
}
