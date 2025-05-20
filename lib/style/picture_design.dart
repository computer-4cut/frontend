library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

Widget buildDesignItem(
  int index, [
  bool? useImage,
  bool? usePhoto,
  List<String>? imagePaths,
]) {
  useImage ??= index % 2 != 0;
  usePhoto ??= false;
  bool useLogo = index == 2 || index == 3;
  Color frameColor = useImage ? Colors.transparent : Colors.black;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
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
          child: _buildFrameContent(
            index,
            frameColor,
            useLogo,
            usePhoto,
            imagePaths,
          ),
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
}

Widget _buildFrameContent(
  int index,
  Color frameColor,
  bool useLogo,
  bool usePhoto, [
  List<String>? imagePaths,
]) {
  return Column(
    children: [
      Expanded(
        flex: 9,
        child: _buildCustomGrid(2, 2, useLogo, usePhoto, imagePaths),
      ),
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

Widget _buildCustomGrid(
  int rows,
  int columns,
  bool useLogo,
  bool usePhoto, [
  List<String>? imagePaths,
]) {
  if (usePhoto && imagePaths == null) {
    throw ErrorHint("이미지 경로가 주어져야 하는데, null이 주어졌습니다.");
  }
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
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(0, imagePaths!)
                        : _buildWhiteCell(),
              ),
              Expanded(
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(2, imagePaths!)
                        : _buildWhiteCell(),
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
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(1, imagePaths!)
                        : _buildWhiteCell(),
              ),
              Expanded(
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(3, imagePaths!)
                        : _buildWhiteCell(),
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
              return Expanded(
                child:
                    usePhoto
                        ? _buildPhotoCell(colIndex, imagePaths!)
                        : _buildWhiteCell(),
              );
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

Widget _buildPhotoCell(int index, List<String> imagePaths) {
  return Container(
    margin: const EdgeInsets.all(5.0),
    color: Colors.transparent,
    child:
        index < imagePaths.length
            ? Image.file(File(imagePaths[index]), fit: BoxFit.cover)
            : Container(color: Colors.grey.shade200),
  );
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
