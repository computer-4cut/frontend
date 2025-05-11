import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'dart:async';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _countdown = 10;
  late Timer _timer;
  int _currentImageIndex = 1;
  final int _maxImages = 6;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _countdown = 10;
          _currentImageIndex = _currentImageIndex < _maxImages ? _currentImageIndex + 1 : 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '카메라를 봐주세요!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomFontFamily.dohyeon,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: Text(
              '$_currentImageIndex / $_maxImages',
              style: const TextStyle(
                color: Colors.white,
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
