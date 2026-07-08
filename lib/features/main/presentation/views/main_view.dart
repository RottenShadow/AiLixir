import 'package:ailixir/core/services/navigation/navigation_service.dart';
import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/features/chatbot/presentation/views/chatbot_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/main_view_body.dart';
import 'package:ailixir/features/auth/presentation/widgets/user_auth_listener.dart';

class MainView extends StatelessWidget {
  static const routeName = '/main';
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          UserAuthListener(child: MainViewBody()),
          _DraggableChatIcon(),
        ],
      ),
    );
  }
}

class _DraggableChatIcon extends StatefulWidget {
  const _DraggableChatIcon();

  @override
  State<_DraggableChatIcon> createState() => _DraggableChatIconState();
}

class _DraggableChatIconState extends State<_DraggableChatIcon> {
  Offset _relativePosition = const Offset(1.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final gap = 8.w;
    final buttonSize = 40.w;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxX = (constraints.maxWidth - buttonSize - 2 * gap).clamp(
          0.0,
          double.infinity,
        );
        final maxY =
            (constraints.maxHeight - buttonSize - 2 * gap - bottomInset).clamp(
              0.0,
              double.infinity,
            );

        final absoluteX = gap + _relativePosition.dx * maxX;
        final absoluteY = gap + _relativePosition.dy * maxY;

        return Stack(
          children: [
            Positioned(
              left: absoluteX,
              top: absoluteY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final newAbsX = (absoluteX + details.delta.dx).clamp(
                      gap,
                      gap + maxX,
                    );
                    final newAbsY = (absoluteY + details.delta.dy).clamp(
                      gap,
                      gap + maxY,
                    );
                    _relativePosition = Offset(
                      maxX > 0 ? (newAbsX - gap) / maxX : 0.0,
                      maxY > 0 ? (newAbsY - gap) / maxY : 0.0,
                    );
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    _relativePosition = Offset(
                      _relativePosition.dx < 0.5 ? 0.0 : 1.0,
                      _relativePosition.dy,
                    );
                  });
                },
                child: FloatingActionButton.small(
                  backgroundColor: AppColors.brandBlue,
                  onPressed: () => context.navigateTo(ChatbotView.routeName),
                  child: const Icon(Icons.assistant),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
