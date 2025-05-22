import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'package:commit4cut/util.dart';
import 'package:commit4cut/style/picture_design.dart';
import 'dart:ui' as ui;
import 'dart:io';
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
  final GlobalKey _savePhotoKey = GlobalKey(); // 저장용 별도 키
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

  // 디자인 인덱스에 따른 디자인 위젯 반환 (전체 - 미리보기용)
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

  // 저장용 위젯 - "디자인 X" 텍스트 제외하고 프레임만
  Widget _buildPhotoCardForSave() {
    int designIndex = _designIndex ?? 0;
    bool useImage = designIndex % 2 != 0; // 1, 3번 디자인은 배경 이미지 사용
    bool useLogo = designIndex == 2 || designIndex == 3;
    Color frameColor = useImage ? Colors.transparent : Colors.black;

    return Container(
      width: 600, // 저장용 고해상도 크기
      height: 800, // 저장용 고해상도 크기  
      decoration: BoxDecoration(
        border: Border.all(color: frameColor, width: 40), // 프레임 두께도 비례 증가
        image: useImage
            ? const DecorationImage(
                image: AssetImage('assets/images/bg1.png'),
                fit: BoxFit.cover,
              )
            : null,
        color: useImage ? null : frameColor,
      ),
      child: _buildFrameContentForSave(designIndex, frameColor, useLogo),
    );
  }

  // 저장용 프레임 내용
  Widget _buildFrameContentForSave(int index, Color frameColor, bool useLogo) {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: _buildCustomGridForSave(2, 2, useLogo, index),
        ),
        if (!useLogo)
          Container(
            height: 80.0, // 고해상도에 맞게 크기 증가
            decoration: BoxDecoration(color: frameColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80.0,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      // Stroke effect
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          '컴공네컷',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 40.0, // 고해상도에 맞게 크기 증가
                            fontFamily: CustomFontFamily.hanna,
                            shadows: [
                              Shadow(
                                offset: const Offset(-2, -2),
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                              Shadow(
                                offset: const Offset(2, -2),
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                              Shadow(
                                offset: const Offset(-2, 2),
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                              Shadow(
                                offset: const Offset(2, 2),
                                color: Colors.black,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Original text
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          '컴공네컷',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 40.0, // 고해상도에 맞게 크기 증가
                            fontFamily: CustomFontFamily.hanna,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 110.0), // 고해상도에 맞게 크기 증가
                SizedBox(
                  height: 120.0, // 고해상도에 맞게 크기 증가
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // 저장용 커스텀 그리드
  Widget _buildCustomGridForSave(int rows, int columns, bool useLogo, int designIndex) {
    bool useImage = designIndex % 2 != 0;
    
    if (useLogo) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildPhotoForSave(0, useImage),
                ),
                Expanded(
                  flex: 1,
                  child: _buildPhotoForSave(2, useImage),
                ),
                _buildTextCellForSave(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildLogoCellForSave(),
                Expanded(
                  flex: 1,
                  child: _buildPhotoForSave(1, useImage),
                ),
                Expanded(
                  flex: 1,
                  child: _buildPhotoForSave(3, useImage),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: List.generate(rows, (rowIndex) {
          return Expanded(
            child: Row(
              children: List.generate(columns, (colIndex) {
                return Expanded(
                  child: _buildPhotoForSave(rowIndex * columns + colIndex, useImage),
                );
              }),
            ),
          );
        }),
      );
    }
  }

  // 저장용 사진 셀
  Widget _buildPhotoForSave(int index, bool useImage) {
    return Container(
      margin: const EdgeInsets.all(6.0), // 고해상도에 맞게 크기 증가
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: useImage
            ? Border.all(color: const Color(0xCC1B1912), width: 2.0) // 고해상도에 맞게 크기 증가
            : null,
      ),
      child: ClipRect(
        child: _imagePaths != null && index < _imagePaths!.length
            ? Image.file(
                File(_imagePaths![index]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : Container(
                color: Colors.white,
                child: useImage
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xCC1B1912), width: 1),
                        ),
                      )
                    : null,
              ),
      ),
    );
  }

  // 저장용 로고 셀
  Widget _buildLogoCellForSave() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0), // 고해상도에 맞게 크기 증가
      color: Colors.transparent,
      height: 80, // 고해상도에 맞게 크기 증가
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }

  // 저장용 텍스트 셀
  Widget _buildTextCellForSave() {
    return Container(
      height: 70, // 고해상도에 맞게 크기 증가
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0), // 고해상도에 맞게 크기 증가
      child: Stack(
        children: [
          // Stroke effect
          Center(
            child: Text(
              '컴공네컷',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 40.0, // 고해상도에 맞게 크기 증가
                fontFamily: CustomFontFamily.hanna,
                shadows: [
                  Shadow(
                    offset: const Offset(-2, -2),
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                  Shadow(
                    offset: const Offset(2, -2),
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                  Shadow(
                    offset: const Offset(-2, 2),
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                  Shadow(
                    offset: const Offset(2, 2),
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Original text
          Center(
            child: Text(
              '컴공네컷',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 40.0, // 고해상도에 맞게 크기 증가
                fontFamily: CustomFontFamily.hanna,
              ),
            ),
          ),
        ],
      ),
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
      body: Stack(
        children: [
          // 저장용 숨겨진 위젯 (사용자에게는 보이지 않음)
          Positioned(
            left: -10000, // 화면 밖으로 숨김
            child: RepaintBoundary(
              key: _savePhotoKey,
              child: _buildPhotoCardForSave(),
            ),
          ),
          // 실제 화면에 보이는 위젯
          Center(
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
        ],
      ),
    );
  }

  // 이미지 저장 기능 (고해상도, 디자인 텍스트 제외)
  void _saveImage() async {
    setState(() {
      _isSaving = true;
      _saveMessage = '저장 중...';
    });

    try {
      // 저장용 RepaintBoundary를 이미지로 캡쳐 (고해상도)
      RenderRepaintBoundary boundary =
          _savePhotoKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0); // 더 높은 해상도
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
