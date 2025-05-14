import 'package:flutter/material.dart';
import 'package:commit4cut/style/picture_design.dart';
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
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildDesignItem(0), // 첫 번째 디자인 (왼쪽 상단)
                              const SizedBox(width: 20.0),
                              buildDesignItem(1), // 두 번째 디자인 (오른쪽 상단)
                            ],
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildDesignItem(2), // 세 번째 디자인 (왼쪽 하단)
                              const SizedBox(width: 20.0),
                              buildDesignItem(3), // 네 번째 디자인 (오른쪽 하단)
                            ],
                          ),
                        ),
                      ],
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
}
