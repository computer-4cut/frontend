library;

import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  /// 그라데이션 색상 효과가 적용된 텍스트를 표시하는 위젯입니다.
  ///
  /// [GradientText] 위젯은 [text] 문자열과 [gradient]를 받아 텍스트에 그라데이션 색상 효과를 적용합니다.
  /// [style] 매개변수를 사용하여 텍스트 스타일을 사용자 정의할 수 있습니다.
  ///
  /// 사용 예:
  /// ```dart
  /// GradientText(
  ///   'Hello, World!',
  ///   gradient: LinearGradient(
  ///     colors: [Colors.blue, Colors.red],
  ///   ),
  ///   style: TextStyle(fontSize: 24),
  /// )
  /// ```
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: Text(text, style: style),
    );
  }
}
