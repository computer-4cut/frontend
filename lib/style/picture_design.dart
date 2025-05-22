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
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: frameColor, width: 20), //좌우간격 조절하는 곳
            image:
                useImage
                    ? const DecorationImage(
                      image: AssetImage('assets/images/bg1.png'),
                      fit: BoxFit.cover,
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
            useImage,
          ),
        ),
      ),
      const SizedBox(height: 8.0),
      FittedBox(
        child: Text(
          '디자인 ${index + 1}',
          style: const TextStyle(
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
  bool? useImage,
]) {
  return Column(
    children: [
      Expanded(
        flex: 9,
        child: _buildCustomGrid(2, 2, useLogo, usePhoto, imagePaths, useImage),
      ),
      if (!useLogo)
        Container(
          height: 40.0,
          decoration: BoxDecoration(color: frameColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40.0,
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
                          fontSize: 20.0,
                          fontFamily: CustomFontFamily.hanna,
                          shadows: [
                            Shadow(
                              offset: const Offset(-1, -1),
                              color: Colors.black,
                              blurRadius: 1,
                            ),
                            Shadow(
                              offset: const Offset(1, -1),
                              color: Colors.black,
                              blurRadius: 1,
                            ),
                            Shadow(
                              offset: const Offset(-1, 1),
                              color: Colors.black,
                              blurRadius: 1,
                            ),
                            Shadow(
                              offset: const Offset(1, 1),
                              color: Colors.black,
                              blurRadius: 1,
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
                          fontSize: 20.0,
                          fontFamily: CustomFontFamily.hanna,
                        ),
                      ),
                    ),
                  ],
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
  bool? useImage,
]) {
  if (usePhoto && imagePaths == null) {
    throw ErrorHint("이미지 경로가 주어져야 하는데, null이 주어졌습니다.");
  }

  if (useLogo) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(0, imagePaths!, useImage)
                        : _buildWhiteCell(useImage),
              ),
              Expanded(
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(2, imagePaths!, useImage)
                        : _buildWhiteCell(useImage),
              ),
              _buildTextCell(),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildLogoCell(),
              Expanded(
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(1, imagePaths!, useImage)
                        : _buildWhiteCell(useImage),
              ),
              Expanded(
                flex: 1,
                child:
                    usePhoto
                        ? _buildPhotoCell(3, imagePaths!, useImage)
                        : _buildWhiteCell(useImage),
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
                child:
                    usePhoto
                        ? _buildPhotoCell(
                          rowIndex * columns + colIndex,
                          imagePaths!,
                          useImage,
                        )
                        : _buildWhiteCell(useImage),
              );
            }),
          ),
        );
      }),
    );
  }
}

Widget _buildWhiteCell([bool? useImage]) {
  return Container(
    margin: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      color: Colors.white,
      border:
          useImage == true
              ? Border.all(color: const Color(0xCC1B1912), width: 1)
              : null,
    ),
  );
}

Widget _buildPhotoCell(int index, List<String> imagePaths, [bool? useImage]) {
  return Container(
    margin: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border:
          useImage == true
              ? Border.all(color: const Color(0xCC1B1912), width: 1.0)
              : null,
    ),
    child: ClipRect(
      child:
          index < imagePaths.length
              ? Image.file(
                File(imagePaths[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
              : Container(color: Colors.grey.shade200),
    ),
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
  return Container(
    height: 35,
    color: Colors.transparent,
    margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
    child: Stack(
      children: [
        // Stroke effect
        Center(
          child: Text(
            '컴공네컷',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
              fontFamily: CustomFontFamily.hanna,
              shadows: [
                Shadow(
                  offset: const Offset(-1, -1),
                  color: Colors.black,
                  blurRadius: 1,
                ),
                Shadow(
                  offset: const Offset(1, -1),
                  color: Colors.black,
                  blurRadius: 1,
                ),
                Shadow(
                  offset: const Offset(-1, 1),
                  color: Colors.black,
                  blurRadius: 1,
                ),
                Shadow(
                  offset: const Offset(1, 1),
                  color: Colors.black,
                  blurRadius: 1,
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
              fontSize: 20.0,
              fontFamily: CustomFontFamily.hanna,
            ),
          ),
        ),
      ],
    ),
  );
}
