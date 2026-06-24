import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/cubits/chat_session_cubit.dart';
import 'package:ailixir/features/chatbot/presentation/widgets/chat_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ChatbotSidebar extends StatelessWidget {
  final ChatSessionCubit cubit;
  const ChatbotSidebar({super.key, required this.cubit});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.slate900,
        border: Border(right: BorderSide(color: AppColors.brandBorder)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 10),
              child: Image.asset(AppImages.logo, width: 30),
            ),
            IconButton(
              hoverColor: AppColors.brandBlue.withAlpha(50),

              onPressed: () {
                if (!cubit.loading) {
                  context.pop();
                }
              },
              //tooltip: "Return to Home",
              icon: Icon(Icons.arrow_back),
            ),
            IconButton(
              hoverColor: AppColors.brandBlue.withAlpha(50),
              onPressed: () async {
                final String? selectedResult = await showGeneralDialog<String>(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: "Dismiss Search",
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ChatSearchDialog(
                      onSearch: (v) {
                        return cubit.responses.where((res) {
                          return res.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                      },
                    );
                  },
                );

                if (selectedResult != null) {
                  await Clipboard.setData(ClipboardData(text: selectedResult));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  }
                }
              },
              //tooltip: "Search Messages",
              icon: Icon(Icons.search),
            ),
            IconButton(
              hoverColor: AppColors.brandBlue.withAlpha(50),

              onPressed: () {},
              //tooltip: "Conversations",
              icon: Icon(Icons.chat),
            ),
            Spacer(),
            IconButton(
              hoverColor: AppColors.brandBlue.withAlpha(50),

              onPressed: () {},
              //tooltip: "Settings",
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
