import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'package:commit4cut/util.dart';
import 'dart:io';

class SelectPicturePage extends StatefulWidget {
  const SelectPicturePage({super.key});

  @override
  State<SelectPicturePage> createState() => _SelectPicturePageState();
}

class _SelectPicturePageState extends State<SelectPicturePage> {
  // 6장의 사진 중 선택 상태를 저장하는 리스트
  final List<bool> _selectedPictures = List.generate(6, (index) => false);
  int _selectedCount = 0;
  int? _designIndex;
  int? _cellIndex;
  List<String>? _photosPaths;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // 라우트 인자 받기
    final Map<String, dynamic>? args = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      _designIndex = args['designIndex'] as int?;
      _cellIndex = args['cellIndex'] as int?;
      _photosPaths = args['photosPaths'] as List<String>?;
      
      if (_photosPaths == null || _photosPaths!.isEmpty) {
        print('경고: 사진 경로가 없거나 비어 있습니다!');
      } else {
        print('받은 디자인 인덱스: $_designIndex');
        print('받은 셀 인덱스: $_cellIndex');
        print('받은 사진 경로 개수: ${_photosPaths!.length}');
      }
    }
  }

  void _togglePicture(int index) {
    if (_selectedPictures[index]) {
      setState(() {
        _selectedPictures[index] = false;
        _selectedCount--;
      });
    } else if (_selectedCount < 4) {
      setState(() {
        _selectedPictures[index] = true;
        _selectedCount++;
      });
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '알림',
            style: TextStyle(
              fontFamily: CustomFontFamily.hsyuji,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '4장의 사진을 모두 선택해주세요!',
            style: TextStyle(fontFamily: CustomFontFamily.hsyuji, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '확인',
                style: TextStyle(
                  fontFamily: CustomFontFamily.hsyuji,
                  fontSize: 18,
                  color: Color(0xFF7D7BEA),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GradientText(
                      '사진을 선택하세요!',
                      style: TextStyle(
                        fontFamily: CustomFontFamily.hsyuji,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF617EF1), Color(0xFF7D49A8)],
                      ),
                    ),
                  ),
                  Text(
                    '$_selectedCount / 4',
                    style: TextStyle(
                      fontFamily: CustomFontFamily.hsyuji,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              // 사진 그리드
              Expanded(
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 3 / 4, // 아이패드 에어 5세대 비율
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _togglePicture(index),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    _selectedPictures[index]
                                        ? Colors.green
                                        : Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _photosPaths != null && index < _photosPaths!.length
                                ? Image.file(
                                    File(_photosPaths![index]),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/1.png',
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                          if (_selectedPictures[index])
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // 안내 문구
              Center(
                child: Text(
                  '갯수에 맞게 사진을 선택해 주세요!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: CustomFontFamily.hsyuji,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: GradientButton(
                  text: '다음으로 넘어가기',
                  onPressed: () {
                    if (_selectedCount == 4) {
                      // 선택된 사진들의 경로만 추출
                      List<String> selectedPhotos = [];
                      for (int i = 0; i < _selectedPictures.length; i++) {
                        if (_selectedPictures[i] && _photosPaths != null && i < _photosPaths!.length) {
                          selectedPhotos.add(_photosPaths![i]);
                        }
                      }
                      // 로딩 페이지로 이동하면서 선택된 사진과 디자인 인덱스 전달
                      Navigator.pushNamed(
                        context, 
                        '/loading',
                        arguments: {
                          'designIndex': _designIndex ?? 0,
                          'imagePaths': selectedPhotos,
                        },
                      );
                    } else {
                      _showWarningDialog();
                    }
                  },
                  borderRadius: 18,
                  width: 500,
                  height: 80,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
