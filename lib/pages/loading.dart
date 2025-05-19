import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key,
    required this.designIndex,
    required this.imagePath,
  });

  final int designIndex;
  final List<String> imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7D7BEA)),
              strokeWidth: 5,
            ),
            const SizedBox(height: 20),
            Text(
              '사진을 처리중입니다...',
              style: TextStyle(
                fontFamily: CustomFontFamily.hsyuji,
                fontSize: 24,
                color: Color(0xFF7D7BEA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
