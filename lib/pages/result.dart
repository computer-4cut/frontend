import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'package:commit4cut/util.dart';
import 'package:commit4cut/style/picture_design.dart';
import 'package:commit4cut/services/qr_api_service.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
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
  final GlobalKey _savePhotoKey = GlobalKey(); // QR 코드 생성용 별도 키
  bool _isGeneratingQR = false;
  String _qrMessage = '';

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
      width: 328, // 정확한 비율: 1640/5.0 = 328
      height: 472, // 정확한 비율: 2360/5.0 = 472
      decoration: BoxDecoration(
        border: Border.all(color: frameColor, width: 20), // 테두리 더 넓게 (10 -> 35)
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
            height: 28.0, // 테두리가 커진 만큼 조정
            decoration: BoxDecoration(color: frameColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 28.0,
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
                            fontSize: 15.0, // 테두리가 커진 만큼 조정
                            fontFamily: CustomFontFamily.hanna,
                            shadows: [
                              Shadow(
                                offset: const Offset(-0.8, -0.8),
                                color: Colors.black,
                                blurRadius: 0.8,
                              ),
                              Shadow(
                                offset: const Offset(0.8, -0.8),
                                color: Colors.black,
                                blurRadius: 0.8,
                              ),
                              Shadow(
                                offset: const Offset(-0.8, 0.8),
                                color: Colors.black,
                                blurRadius: 0.8,
                              ),
                              Shadow(
                                offset: const Offset(0.8, 0.8),
                                color: Colors.black,
                                blurRadius: 0.8,
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
                            fontSize: 15.0, // 테두리가 커진 만큼 조정
                            fontFamily: CustomFontFamily.hanna,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40.0), // 테두리가 커진 만큼 조정
                SizedBox(
                  height: 42.0, // 테두리가 커진 만큼 조정
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
      margin: const EdgeInsets.all(2.0), // 여백 더 줄임
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: useImage
            ? Border.all(color: const Color(0xCC1B1912), width: 0.8) // 테두리 더 얇게
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
                          border: Border.all(color: const Color(0xCC1B1912), width: 0.8),
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
      margin: const EdgeInsets.only(left: 3.0, right: 3.0), // 여백 조정
      color: Colors.transparent,
      height: 50, // 테두리가 커진 만큼 조정
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
  // 저장용 텍스트 셀
  Widget _buildTextCellForSave() {
    return Container(
      height: 26, // 테두리가 커진 만큼 조정
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0), // 여백 조정
      child: Stack(
        children: [
          // Stroke effect
          Center(
            child: Text(
              '컴공네컷',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15.0, // 테두리가 커진 만큼 조정
                fontFamily: CustomFontFamily.hanna,
                shadows: [
                  Shadow(
                    offset: const Offset(-0.8, -0.8),
                    color: Colors.black,
                    blurRadius: 0.8,
                  ),
                  Shadow(
                    offset: const Offset(0.8, -0.8),
                    color: Colors.black,
                    blurRadius: 0.8,
                  ),
                  Shadow(
                    offset: const Offset(-0.8, 0.8),
                    color: Colors.black,
                    blurRadius: 0.8,
                  ),
                  Shadow(
                    offset: const Offset(0.8, 0.8),
                    color: Colors.black,
                    blurRadius: 0.8,
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
                fontSize: 15.0, // 테두리가 커진 만큼 조정
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
          // QR 코드 생성용 숨겨진 위젯 (사용자에게는 보이지 않음)
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
                const SizedBox(height: 30),
                // QR 코드 생성 버튼 (유일한 액션 버튼)
                GradientButton(
                  text: 'QR 코드 생성',
                  onPressed: _isGeneratingQR ? null : () => _generateQRCode(),
                  width: 200,
                  height: 50,
                  fontSize: 20,
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  ),
                ),
                if (_qrMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _qrMessage,
                      style: TextStyle(
                        fontFamily: CustomFontFamily.dohyeon,
                        fontSize: 16,
                        color: _qrMessage.contains('성공') ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // 처음으로 버튼
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

  // QR 코드 생성 기능
  void _generateQRCode() async {
    setState(() {
      _isGeneratingQR = true;
      _qrMessage = 'QR 코드 생성 중...';
    });

    try {
      // 먼저 API 서버 상태 확인
      bool isHealthy = await QRApiService.checkHealth();
      if (!isHealthy) {
        setState(() {
          _qrMessage = 'QR 코드 서버에 연결할 수 없습니다.';
        });
        return;
      }

      // 임시 파일로 이미지 저장 (QR 코드 생성용)
      File? tempImageFile = await _saveImageToTempFile();
      if (tempImageFile == null) {
        setState(() {
          _qrMessage = 'QR 코드 생성 실패: 이미지 처리 오류';
        });
        return;
      }

      // URL QR 코드 생성 (권장) - 더 큰 QR 코드
      Uint8List? qrImageBytes = await QRApiService.generateUrlQRCode(
        imageFile: tempImageFile,
        boxSize: 15, // 더 큰 QR 코드를 위해 증가
        border: 6,   // 테두리도 증가
        errorCorrection: 'M', // 중간 수준 오류 수정
      );

      // 임시 파일 삭제
      await tempImageFile.delete();

      if (qrImageBytes != null) {
        setState(() {
          _qrMessage = 'QR 코드 생성 성공!';
        });

        // QR 코드 표시 다이얼로그
        _showQRCodeDialog(qrImageBytes);
      } else {
        setState(() {
          _qrMessage = 'QR 코드 생성 실패: 서버 오류';
        });
      }
    } catch (e) {
      setState(() {
        _qrMessage = 'QR 코드 생성 실패: $e';
      });
    } finally {
      setState(() {
        _isGeneratingQR = false;
      });
    }
  }

  // 임시 파일로 이미지 저장
  Future<File?> _saveImageToTempFile() async {
    try {
      // 저장용 RepaintBoundary를 이미지로 캡쳐
      RenderRepaintBoundary boundary =
          _savePhotoKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        
        // 임시 디렉토리에 파일 저장
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/temp_qr_image_${DateTime.now().millisecondsSinceEpoch}.png';
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(pngBytes);
        
        return tempFile;
      }
      return null;
    } catch (e) {
      print('임시 파일 저장 오류: $e');
      return null;
    }
  }

  // QR 코드 표시 다이얼로그 (큰 팝업)
  void _showQRCodeDialog(Uint8List qrImageBytes) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'QR 코드',
                    style: TextStyle(
                      fontFamily: CustomFontFamily.hsyuji,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'QR 코드를 스캔하여 네컷 사진을 확인하세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: CustomFontFamily.dohyeon,
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 큰 QR 코드 표시
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        qrImageBytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '화면을 터치하여 닫기',
                    style: TextStyle(
                      fontFamily: CustomFontFamily.dohyeon,
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
