import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'package:commit4cut/util.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int? _designIndex;
  List<String>? _imagePaths;
  GlobalKey _photoCardKey = GlobalKey();
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
    
    // 디자인 템플릿에 따라 다른 레이아웃 반환
    switch (designIndex) {
      case 0:
        return _buildBasicDesign();
      case 1:
        return _buildDesignWithBackground();
      case 2:
        return _buildDesignWithLogo();
      case 3:
        return _buildDesignWithLogoAndBackground();
      default:
        return _buildBasicDesign();
    }
  }

  // 기본 디자인 (2x2 그리드)
  Widget _buildBasicDesign() {
    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildPhotoCell(0)),
                      Expanded(child: _buildPhotoCell(1)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildPhotoCell(2)),
                      Expanded(child: _buildPhotoCell(3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '컴공네컷',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    fontFamily: CustomFontFamily.hanna,
                  ),
                ),
                const SizedBox(width: 20.0),
                SizedBox(
                  height: 30.0,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ) ,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 배경이 있는 디자인
  Widget _buildDesignWithBackground() {
    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/bg1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildPhotoCell(0)),
                        SizedBox(width: 8),
                        Expanded(child: _buildPhotoCell(1)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildPhotoCell(2)),
                        SizedBox(width: 8),
                        Expanded(child: _buildPhotoCell(3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단 텍스트와 로고 - 반투명 배경
          Container(
            height: 40.0,
            color: Colors.black.withOpacity(0.7), // 투명도 추가
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '컴공네컷',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    fontFamily: CustomFontFamily.hanna,
                  ),
                ),
                const SizedBox(width: 20.0),
                SizedBox(
                  height: 30.0,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 로고가 있는 디자인
  Widget _buildDesignWithLogo() {
    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 15),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // 왼쪽 세로 영역
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(flex: 1, child: _buildPhotoCell(0)),
                Expanded(flex: 1, child: _buildPhotoCell(1)),
                Container(
                  height: 35,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      '컴공네컷',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        fontFamily: CustomFontFamily.hanna,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽 세로 영역
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(flex: 1, child: _buildPhotoCell(2)),
                Expanded(flex: 1, child: _buildPhotoCell(3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 로고와 배경이 있는 디자인
  Widget _buildDesignWithLogoAndBackground() {
    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/bg1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          // 왼쪽 세로 영역
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(flex: 1, child: _buildPhotoCell(0)),
                Expanded(flex: 1, child: _buildPhotoCell(1)),
                Container(
                  height: 35,
                  color: Colors.black.withOpacity(0.7), // 투명도 추가
                  child: Center(
                    child: Text(
                      '컴공네컷',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        fontFamily: CustomFontFamily.hanna,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽 세로 영역
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(flex: 1, child: _buildPhotoCell(2)),
                Expanded(flex: 1, child: _buildPhotoCell(3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 개별 사진 셀
  Widget _buildPhotoCell(int index) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      color: Colors.white,
      child: _imagePaths != null && index < _imagePaths!.length
          ? Image.file(
              File(_imagePaths![index]),
              fit: BoxFit.cover,
            )
          : Container(color: Colors.grey.shade200),
    );
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
            RepaintBoundary(
              key: _photoCardKey,
              child: _buildPhotoCard(),
            ),
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
                    color: _saveMessage.contains('성공') ? Colors.green : Colors.red,
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

  // 이미지 저장 기능 (미구현)
  void _saveImage() async {
    setState(() {
      _isSaving = true;
      _saveMessage = '저장 중...';
    });

    try {
      // 실제 프로젝트에서는 RepaintBoundary를 이미지로 캡쳐하고 저장하는 코드를 구현해야 합니다.
      // 이 예제에서는 간단히 성공 메시지만 표시합니다.
      await Future.delayed(Duration(seconds: 2)); // 저장 시간 시뮬레이션
      
      setState(() {
        _saveMessage = '저장 성공! 갤러리에서 확인하세요.';
      });
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
