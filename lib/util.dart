library;

import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

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

class GradientButton extends StatelessWidget {
  /// 그라데이션 효과가 적용된 버튼을 표시하는 위젯입니다.
  ///
  /// ```json
  /// [GradientButton] 위젯은 [text]와 [onPressed] 콜백을 받아 그라데이션 배경의 버튼을 생성합니다.
  /// [onPressed]가 null이면 버튼이 클릭되어도 아무 동작도 수행하지 않습니다.
  /// ```
  ///
  /// 사용 예:
  /// ```dart
  /// GradientButton(
  ///   text: 'Hello, World!',
  ///   onPressed: () {
  ///     // 버튼 클릭 동작
  ///   },
  /// )
  /// ```
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF617EF1), Color(0xFF7D49A8)],
    ),
    this.borderRadius = 30.0,
    this.width = 400.0,
    this.height = 115.0,
    this.fontSize = 60.0,
    this.fontFamily,
  });

  final String text;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double borderRadius;
  final double width;
  final double height;
  final double fontSize;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        shadowColor: Colors.black.withValues(alpha: 1),
        elevation: 10,
        backgroundColor: Colors.transparent,
      ),
      onPressed: onPressed ?? () {},
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: width, maxHeight: height),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: fontFamily ?? CustomFontFamily.hsyuji,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
