import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'package:commit4cut/util.dart';
import 'package:commit4cut/style/picture_design.dart';
import 'dart:ui' as ui;
// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int? _designIndex;
  List<String>? _imagePaths;
  final GlobalKey _photoCardKey = GlobalKey();
  bool _isSaving = false;
  String _saveMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 라우트 인자 받기
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _designIndex = args['designIndex'] as int?;
      _imagePaths = args['imagePaths'] as List<String>?;

      print('결과 페이지 - 받은 디자인 인덱스: $_designIndex');
      if (_imagePaths != null) {
        print('결과 페이지 - 받은 이미지 경로 수: ${_imagePaths!.length}');
      }
    }
  }

  // 디자인 인덱스에 따른 디자인 위젯 반환
  Widget _buildPhotoCard() {
    int designIndex = _designIndex ?? 0;

    // picture_design.dart의 buildDesignItem을 사용하여 디자인 생성
    Widget designWidget = buildDesignItem(
      designIndex,
      designIndex % 2 != 0, // 1, 3번 디자인은 배경 이미지 사용
      _imagePaths != null, // 이미지 경로가 있으면 사진 표시
      _imagePaths, // 이미지 경로 전달
    );

    // 크기 및 비율 조정을 위해 Container로 감싸기
    return SizedBox(width: 350, height: 500, child: designWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '네컷 완성!',
          style: TextStyle(
            fontFamily: CustomFontFamily.hsyuji,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 사진 합성 결과
            RepaintBoundary(key: _photoCardKey, child: _buildPhotoCard()),
            const SizedBox(height: 20),
            // 저장 버튼
            GradientButton(
              text: '저장하기',
              onPressed: _isSaving ? null : () => _saveImage(),
              width: 200,
              height: 50,
              fontSize: 20,
            ),
            if (_saveMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _saveMessage,
                  style: TextStyle(
                    fontFamily: CustomFontFamily.dohyeon,
                    fontSize: 16,
                    color:
                        _saveMessage.contains('성공') ? Colors.green : Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // 공유 버튼
            GradientButton(
              text: '처음으로',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              width: 200,
              height: 50,
              fontSize: 20,
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.blueGrey],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 저장 기능
  void _saveImage() async {
    setState(() {
      _isSaving = true;
      _saveMessage = '저장 중...';
    });

    try {
      // RepaintBoundary를 이미지로 캡쳐
      RenderRepaintBoundary boundary =
          _photoCardKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // 갤러리에 저장
        final result = await ImageGallerySaver.saveImage(
          pngBytes,
          quality: 100,
          name: 'commit4cut_${DateTime.now().millisecondsSinceEpoch}.png',
        );

        if (result['isSuccess']) {
          setState(() {
            _saveMessage = '저장 성공! 갤러리에서 확인하세요.';
          });
        } else {
          setState(() {
            _saveMessage = '저장 실패: 권한을 확인해주세요.';
          });
        }
      } else {
        setState(() {
          _saveMessage = '저장 실패: 이미지 변환 오류';
        });
      }
    } catch (e) {
      setState(() {
        _saveMessage = '저장 실패: $e';
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }
}
