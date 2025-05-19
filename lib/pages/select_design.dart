import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

class SelectDesignPage extends StatefulWidget {
  const SelectDesignPage({super.key});

  @override
  SelectDesignPageState createState() => SelectDesignPageState();
}

class SelectDesignPageState extends State<SelectDesignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 72.0,
                vertical: 60.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20.0),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Color(0xFF8F9DEB), Color(0xFF7577CF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: Text(
                      '디자인을 선택하세요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: CustomFontFamily.hsyuji,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 40.0,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(4, (index) {
                        bool useImage = index % 2 == 0; // 0, 2번 인덱스
                        Color frameColor =
                            useImage
                                ? Colors
                                    .transparent // 이미지 배경일 때는 투명 (이미지가 보이도록)
                                : Colors.black; // 이미지 아닐 때는 검은색

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: frameColor,
                                    width: 15,
                                  ),
                                  image:
                                      useImage
                                          ? const DecorationImage(
                                            image: AssetImage(
                                              'assets/images/bg1.png',
                                            ),
                                            fit: BoxFit.fitWidth,
                                          )
                                          : null,
                                  color: useImage ? null : frameColor,
                                ),
                                child: buildFrameContent(index, frameColor),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const FittedBox(
                              child: Text(
                                '기본 디자인',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  fontFamily: CustomFontFamily.dohyeon,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildFrameContent(int index, Color frameColor) {
    Color textColor = Colors.white;

    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // 그리드와 텍스트 사이 여백 추가
            child: buildGridLayout(2, 2),
          ),
        ),
        Container(
          height: 30.0,
          decoration: BoxDecoration(color: frameColor),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '컴공네컷',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    fontFamily: CustomFontFamily.dohyeon,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset('assets/images/1.png', width: 15, height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGridLayout(int rows, int columns) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 0.85,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        return buildWhiteCell(0, index);
      },
    );
  }

  Widget buildWhiteCell(int designIndex, int cellIndex) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/camera_test',
          arguments: {'designIndex': designIndex, 'cellIndex': cellIndex},
        );
      },
      child: Container(margin: const EdgeInsets.all(5.0), color: Colors.white),
    );
  }
}
