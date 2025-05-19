# commit4cut 프로젝트

## 프로젝트 개요

- `commit4cut`은 포토 부스 스타일의 사진 촬영 및 편집 앱입니다.
- 사용자는 4장의 연속 사진을 촬영하고 다양한 디자인 템플릿을 적용할 수 있습니다.

## 주요 기능

1. 카메라 기능: 전면 카메라를 사용한 셀피 촬영
2. 타이머 카운트다운: 촬영 전 10초 카운트다운
3. 연속 촬영: 총 4장의 사진 연속 촬영
4. 디자인 선택: 다양한 디자인 템플릿 적용
5. 사진 저장: 기기 내부 저장소에 사진 저장

## 기술 스택

- Flutter/Dart
- 카메라: camera 패키지
- 파일 저장: path_provider 패키지

## 파일 구조

- `lib/pages/`: 앱의 주요 화면들
  - `start_page.dart`: 시작 화면
  - `camera.dart`: 카메라 촬영 화면
  - `select_design.dart`: 디자인 선택 화면
  - `loading.dart`: 로딩 화면
  - `select_picture.dart`: 사진 선택 화면
- `lib/style/`: 스타일 관련 파일
  - `font.dart`: 폰트 스타일 정의
  - `picture_design.dart`: 사진 디자인 템플릿 정의

## 코딩 컨벤션

- 클래스명: PascalCase (예: `CameraPage`)
- 변수 및 함수명: camelCase (예: `_initializeCamera()`)
- private 변수/함수: 언더스코어 접두사 (예: `_capturedImagePaths`)
- 주석: 한글 주석 사용, 주석은 꼭 필요한 곳에만 쓸 것, 변수명 등으로 유추할 수 있는 경우 주석 달지 않을 것
