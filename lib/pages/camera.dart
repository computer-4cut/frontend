import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '카메라를 선택하세요!',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(4, (index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 4.0),
                            color: Colors.black,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 5,
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(4, (gridIndex) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      '컴공네컷',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: CustomFontFamily.dohyeon,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      FittedBox(
                        child: const Text(
                          '기본 디자인',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: CustomFontFamily.dohyeon,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
