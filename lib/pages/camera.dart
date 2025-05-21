import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'dart:async';


/// CameraPage 위젯
///
/// 사용자가 4장의 사진을 연속으로 촬영하는 화면
/// @copilot-context 이 화면은 선택한 디자인 인덱스를 전달받아 사진 촬영 후 저장합니다
/// @copilot-platform-support 주로 모바일 플랫폼(iOS, Android)을 지원합니다
class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.index});

  final int index;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _countdown = 10;
  Timer? _timer;
  int _currentImageIndex = 1;
  final int _maxImages = 6;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // 위젯이 마운트된 상태인지 확인
        setState(() {
          if (_countdown > 1) {
            _countdown--;
          } else {
            _countdown = 10;
            _currentImageIndex =
                _currentImageIndex < _maxImages ? _currentImageIndex + 1 : 1;
          }
        });
      } else {
        timer.cancel(); // 마운트되지 않은 상태라면 타이머 취소
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 5.0),
            ),
            margin: const EdgeInsets.all(10.0),
            child: Center(
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.all(10.0),
              ),
            ),
          ),
          Center(
            child: Text(
              '$_countdown',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 120,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '카메라를 봐주세요!',
                style: TextStyle(
                  color: Colors.grey,

                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomFontFamily.dohyeon,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: Text(
              '$_currentImageIndex / $_maxImages',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
