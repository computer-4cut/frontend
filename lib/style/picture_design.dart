library;

import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

Widget buildDesignItem(int index, [bool? useImage]) {
  useImage ??= index % 2 != 0;
  bool useLogo = index == 2 || index == 3;
  Color frameColor = useImage ? Colors.transparent : Colors.black;

  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: frameColor, width: 15),
              image:
                  useImage
                      ? const DecorationImage(
                        image: AssetImage('assets/images/bg1.png'),
                        fit: BoxFit.fitWidth,
                      )
                      : null,
              color: useImage ? null : frameColor,
            ),
            child: _buildFrameContent(index, frameColor, useLogo),
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
    ),
  );
}

Widget _buildFrameContent(int index, Color frameColor, bool useLogo) {
  return Column(
    children: [
      Expanded(flex: 9, child: _buildCustomGrid(2, 2, useLogo)),
      if (!useLogo)
        Container(
          height: 40.0, // 전체 Row 높이 증가
          decoration: BoxDecoration(color: frameColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬로 변경
            children: [
              Container(
                height: 40.0, // Match the parent container height
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    '컴공네컷',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0,
                      fontFamily: CustomFontFamily.hanna,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 55.0),
              SizedBox(
                height: 60.0,
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

Widget _buildCustomGrid(int rows, int columns, bool useLogo) {
  if (useLogo) {
    // 두 번째 이미지처럼 비대칭 레이아웃 생성
    return Row(
      children: [
        // 왼쪽 세로로 큰 셀들 (2개 + 텍스트)
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1, // 동일한 flex 값 설정
                child: _buildWhiteCell(),
              ),
              Expanded(
                flex: 1, // 동일한 flex 값 설정
                child: _buildWhiteCell(),
              ),
              _buildTextCell(), // 고정 크기
            ],
          ),
        ),
        // 오른쪽 영역
        Expanded(
          flex: 1,
          child: Column(
            children: [
              // 로고 (상단) - 고정 크기
              _buildLogoCell(),
              // 중간 영역 - 나머지 공간 채움
              Expanded(
                flex: 1, // 동일한 flex 값 설정
                child: _buildWhiteCell(),
              ),
              Expanded(
                flex: 1, // 동일한 flex 값 설정
                child: _buildWhiteCell(),
              ),
            ],
          ),
        ),
      ],
    );
  } else {
    // 기본 그리드 레이아웃
    return Column(
      children: List.generate(rows, (rowIndex) {
        return Expanded(
          child: Row(
            children: List.generate(columns, (colIndex) {
              return Expanded(child: _buildWhiteCell());
            }),
          ),
        );
      }),
    );
  }
}

Widget _buildWhiteCell() {
  return Container(margin: const EdgeInsets.all(5.0), color: Colors.white);
}

Widget _buildLogoCell() {
  return Container(
    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
    color: Colors.transparent,
    height: 40,
    child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
  );
}

Widget _buildTextCell() {
  Color textColor = Colors.white;
  return Container(
    height: 35,
    color: Colors.transparent,
    margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
    child: Center(
      child: Text(
        '컴공네컷',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
          fontFamily: CustomFontFamily.hanna,
        ),
      ),
    ),
  );
}
