import 'package:ailixir/core/constants/app_images.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/utils/toast/app_toast.dart';
import 'package:ailixir/core/widgets/text_field/custom_text_field.dart';
import 'package:ailixir/features/chatbot/presentation/cubits/chat_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotSidebar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final VoidCallback onExit;
  final ChatSessionCubit cubit;

  const ChatbotSidebar({
    super.key,
    required this.isExpanded,
    required this.onOpen,
    required this.onClose,
    required this.onExit,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSessionCubit, ChatSessionState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          width: isExpanded ? 286.w : 64.w,
          decoration: BoxDecoration(
            color: AppColors.slate1100,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF071120),
                const Color(0xFF081624),
                const Color(0xFF071421),
              ],
              stops: const [0, 0.58, 1],
            ),
            border: Border(
              right: BorderSide(color: AppColors.cyan400.withAlpha(14)),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(26),
                blurRadius: 18,
                offset: const Offset(4, 0),
              ),
              BoxShadow(
                color: AppColors.cyan400.withAlpha(10),
                blurRadius: 22,
                offset: const Offset(1, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: ClipRect(
              child: isExpanded
                  ? _ExpandedSidebar(
                      onClose: onClose,
                      onExit: onExit,
                      cubit: cubit,
                      state: state,
                    )
                  : _Rail(onOpen: onOpen, onExit: onExit),
            ),
          ),
        );
      },
    );
  }
}

class _Rail extends StatelessWidget {
  final VoidCallback onOpen;
  final VoidCallback onExit;

  const _Rail({required this.onOpen, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Tooltip(
            message: "Exit chat",
            child: InkWell(
              onTap: onExit,
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: _LogoMark(size: 34.w),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          IconButton(
            onPressed: onOpen,
            tooltip: "Conversations",
            icon: const Icon(Icons.chat_bubble_outline),
            color: AppColors.white,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            tooltip: "Settings",
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.slate300,
          ),
        ],
      ),
    );
  }
}

class _ExpandedSidebar extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onExit;
  final ChatSessionCubit cubit;
  final ChatSessionState state;
  const _ExpandedSidebar({
    required this.onClose,
    required this.onExit,
    required this.cubit,
    required this.state,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExpandedSidebarState();
  }
}

class _ExpandedSidebarState extends State<_ExpandedSidebar> {
  @override
  void initState() {
    super.initState();
    widget.cubit.setSession(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: widget.onExit,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Row(
                      children: [
                        _LogoMark(size: 36.w),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ailixir",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "AI molecular workspace",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.slate400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 42.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.brandBlue.withAlpha(210),
                    AppColors.cyan600.withAlpha(178),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.cyan300.withAlpha(46)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandBlue.withAlpha(42),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  bool success = await widget.cubit.newSession();
                  if (!success) {
                    if (context.mounted) {
                      AppToast.showErrorToast(
                        context: context,
                        message: "Failed to create new conversation",
                      );
                    }
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text("New chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.slate50,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          CustomTextField(
            onChanged: widget.cubit.onSearch,
            controller: widget.cubit.searchController,
            hint: "Search Conversation",
            prefixIcon: Icon(Icons.search, size: 18, color: AppColors.slate400),
            borderRadius: 12.r,
          ),
          SizedBox(height: 25.h),
          if (widget.state is ChatSessionSuccess)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(widget.cubit.sessions.length, (idx) {
                    return _RecentChatRow(
                      title: widget.cubit.sessions[idx].title,
                      isActive: idx == widget.cubit.currentSession,
                      onClick: () async {
                        widget.cubit.setSession(idx);
                        setState(() {});
                      },
                    );
                  }),
                ),
              ),
            ),
          if ((widget.state is! ChatSessionSuccess)) Spacer(),
          _BottomSettings(),
        ],
      ),
    );
  }
}

class _RecentChatRow extends StatelessWidget {
  final String title;
  final bool isActive;
  final void Function() onClick;

  const _RecentChatRow({
    required this.title,
    this.isActive = false,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.blue900.withAlpha(62)
            : const Color(0xFF071120).withAlpha(104),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isActive
              ? AppColors.cyan300.withAlpha(46)
              : AppColors.cyan400.withAlpha(12),
        ),
      ),
      child: InkWell(
        onTap: onClick,
        splashColor: AppColors.brandBlue,
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 16.sp,
              color: isActive ? AppColors.cyan200 : AppColors.slate400,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodysmall.copyWith(
                  color: isActive ? AppColors.slate50 : AppColors.slate300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF071120).withAlpha(108),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cyan400.withAlpha(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.brandBlue.withAlpha(72),
            child: Icon(
              Icons.person_outline,
              size: 18.sp,
              color: AppColors.white,
            ),
          ),

          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Settings",
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelmedium.copyWith(
                color: AppColors.slate200,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.slate300,
          ),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  final double size;

  const _LogoMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(AppImages.logo, fit: BoxFit.contain),
    );
  }
}

//class ChatbotSidebar extends StatelessWidget {
//  final ChatSessionCubit cubit;
//  const ChatbotSidebar({super.key, required this.cubit});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      decoration: const BoxDecoration(
//        color: AppColors.slate900,
//        border: Border(right: BorderSide(color: AppColors.brandBorder)),
//      ),
//      child: SafeArea(
//        child: Column(
//          children: [
//            Padding(
//              padding: EdgeInsetsGeometry.symmetric(vertical: 10),
//              child: Image.asset(AppImages.logo, width: 30),
//            ),
//            IconButton(
//              hoverColor: AppColors.brandBlue.withAlpha(50),
//
//              onPressed: () {
//                if (!cubit.loading) {
//                  context.pop();
//                }
//              },
//              //tooltip: "Return to Home",
//              icon: Icon(Icons.arrow_back),
//            ),
//            IconButton(
//              hoverColor: AppColors.brandBlue.withAlpha(50),
//              onPressed: () async {
//                final String? selectedResult = await showGeneralDialog<String>(
//                  context: context,
//                  barrierDismissible: true,
//                  barrierLabel: "Dismiss Search",
//                  transitionDuration: const Duration(milliseconds: 300),
//                  transitionBuilder:
//                      (context, animation, secondaryAnimation, child) {
//                        return FadeTransition(opacity: animation, child: child);
//                      },
//                  pageBuilder: (context, animation, secondaryAnimation) {
//                    return ChatSearchDialog(
//                      onSearch: (v) {
//                        return cubit.responses.where((res) {
//                          return res.toLowerCase().contains(v.toLowerCase());
//                        }).toList();
//                      },
//                    );
//                  },
//                );
//
//                if (selectedResult != null) {
//                  await Clipboard.setData(ClipboardData(text: selectedResult));
//                  if (context.mounted) {
//                    ScaffoldMessenger.of(context).showSnackBar(
//                      const SnackBar(content: Text('Copied to clipboard')),
//                    );
//                  }
//                }
//              },
//              //tooltip: "Search Messages",
//              icon: Icon(Icons.search),
//            ),
//            IconButton(
//              hoverColor: AppColors.brandBlue.withAlpha(50),
//
//              onPressed: () {},
//              //tooltip: "Conversations",
//              icon: Icon(Icons.chat),
//            ),
//            Spacer(),
//            IconButton(
//              hoverColor: AppColors.brandBlue.withAlpha(50),
//
//              onPressed: () {},
//              //tooltip: "Settings",
//              icon: Icon(Icons.settings),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
