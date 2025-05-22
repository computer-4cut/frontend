import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  int? _designIndex;
  List<String>? _imagePaths;

  @override
  void initState() {
    super.initState();
    // 페이지 로딩 후 2초 후에 결과 페이지로 이동
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _navigateToResultPage();
      }
    });
  }

  void _navigateToResultPage() {
    // 결과 페이지로 이동하면서 데이터 전달
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {'designIndex': _designIndex, 'imagePaths': _imagePaths},
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 라우트 인자 받기
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _designIndex = args['designIndex'] as int?;
      _imagePaths = args['imagePaths'] as List<String>?;

      print('받은 디자인 인덱스: $_designIndex');
      print('받은 이미지 경로: $_imagePaths');
    }
  }

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
