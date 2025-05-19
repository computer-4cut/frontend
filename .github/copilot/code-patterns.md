# commit4cut 코드 패턴 가이드

## 위젯 구조 패턴

### 페이지 기본 구조

```dart
import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        // 내용
      ),
    );
  }
}
```

### 카메라 초기화 패턴

```dart
Future<void> _initializeCamera() async {
  try {
    // 사용 가능한 카메라 목록 가져오기
    _cameras = await availableCameras();

    if (_cameras != null && _cameras!.isNotEmpty) {
      // 전면 카메라 찾기
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  } catch (e) {
    print("카메라 초기화 오류: $e");
  }
}
```

### 파일 저장 패턴

```dart
Future<void> _initSaveDirectory() async {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      _appDocumentsPath = appDocumentsDir.path;

      _photoDirectory = path.join(_appDocumentsPath, 'commit4cut_photos');
      final Directory photoDir = Directory(_photoDirectory);

      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }
    }
  } catch (e) {
    print("저장 경로 초기화 오류: $e");
  }
}

Future<String> _savePermanentPhoto(String tempPath) async {
  try {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filename = 'commit4cut_${_currentImageIndex}_$timestamp.jpg';
    final String destPath = path.join(_photoDirectory, filename);

    final File tempFile = File(tempPath);
    final File savedFile = await tempFile.copy(destPath);

    return savedFile.path;
  } catch (e) {
    print("사진 저장 오류: $e");
    return tempPath;
  }
}
```

## 자주 사용되는 UI 패턴

### 스타일이 적용된 텍스트

```dart
Text(
  '텍스트 내용',
  style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: CustomFontFamily.dohyeon,
  ),
)
```

### 페이지 이동

```dart
Navigator.pushNamed(
  context,
  '/route_name',
  arguments: {
    'key': value,
  },
);
```

### 중앙 정렬된 컨테이너

```dart
Center(
  child: Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: // 내용
  ),
)
```
