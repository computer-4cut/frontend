import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

class SelectPicturePage extends StatefulWidget {
  const SelectPicturePage({super.key});

  @override
  State<SelectPicturePage> createState() => _SelectPicturePageState();
}

class _SelectPicturePageState extends State<SelectPicturePage> {
  final List<bool> _selectedPictures = List.generate(6, (index) => false);
  int _selectedCount = 0;

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
              // 상단 텍스트
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '사진을 선택하세요!',
                      style: TextStyle(
                        fontFamily: CustomFontFamily.hsyuji,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7D7BEA),
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
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.asset(
                                  'assets/images/1.png',
                                  width: 300, // 고정된 너비
                                  height: 400, // 고정된 높이
                                ),
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
              // 다음 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedCount == 4) {
                      Navigator.pushNamed(context, '/loading');
                    } else {
                      _showWarningDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7D7BEA), Color(0xFF7DC8EA)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      width: 500,
                      height: 80,
                      alignment: Alignment.center,
                      child: Text(
                        '다음으로 넘어가기',
                        style: TextStyle(
                          fontFamily: CustomFontFamily.hsyuji,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
