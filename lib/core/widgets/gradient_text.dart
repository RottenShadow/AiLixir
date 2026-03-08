import 'package:flutter/material.dart';
import 'package:ailixir/core/themes/app_gradients.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle? style;
  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient = AppGradients.brandBlueGradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style ?? AppTextStyles.bodylarge,
      ),
    );
  }
}
