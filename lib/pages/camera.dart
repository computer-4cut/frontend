import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// CameraPage 위젯
/// 
/// 사용자가 4장의 사진을 연속으로 촬영하는 화면
/// @copilot-context 이 화면은 선택한 디자인 인덱스를 전달받아 사진 촬영 후 저장합니다
/// @copilot-platform-support 주로 모바일 플랫폼(iOS, Android)을 지원합니다
class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.index});

  final int index;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _countdown = 10;
  late Timer _timer;
  int _currentImageIndex = 1;
  final int _maxImages = 4;
  bool _isCounting = true;
  bool _isCapturing = false;
  String _captureStatus = "";

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  final List<String> _capturedImagePaths = [];
  String _appDocumentsPath = "";
  String _photoDirectory = "";

  @override
  void initState() {
    super.initState();
    // 사진 저장 디렉토리 초기화
    _initSaveDirectory();
    // 카메라 초기화
    _initializeCamera();
  }

  Future<void> _initSaveDirectory() async {
    try {
      // 앱 문서 디렉토리 경로 가져오기
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      _appDocumentsPath = appDocumentsDir.path;

      // 사진 저장을 위한 디렉토리 생성
      _photoDirectory = path.join(_appDocumentsPath, 'commit4cut_photos');
      final Directory photoDir = Directory(_photoDirectory);

      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      setState(() {
        _captureStatus = "저장 경로: $_photoDirectory";
      });

      print("사진이 저장될 경로: $_photoDirectory");
    } catch (e) {
      print("디렉토리 초기화 오류: $e");
      setState(() {
        _captureStatus = "저장 경로 초기화 오류: $e";
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // 사용 가능한 카메라 목록 가져오기
      _cameras = await availableCameras();

      if (_cameras != null && _cameras!.isNotEmpty) {
        // 전면 카메라 찾기 (사용자 셀피용)
        final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first, // 전면 카메라가 없으면 첫 번째 카메라 사용
        );

        // 카메라 컨트롤러 초기화
        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        // 카메라 컨트롤러 초기화 대기
        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });

          // 카메라 초기화 완료 후 카운트다운 시작
          _startCountdown();
        }
      } else {
        setState(() {
          _captureStatus = "카메라를 찾을 수 없습니다.";
        });
      }
    } catch (e) {
      setState(() {
        _captureStatus = "카메라 초기화 오류: $e";
      });
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            if (_isCounting) {
              _isCounting = false;
              _capturePhoto(); // 카운트다운이 0이 되면 사진 찍기
            }
          }
        });
      } else {
        _timer.cancel(); // 마운트되지 않은 상태라면 타이머 취소
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      setState(() {
        _captureStatus = "카메라가 준비되지 않았습니다.";
      });
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
        _captureStatus = "촬영 중...";
      });

      // 사진 찍기
      final XFile photo = await _cameraController!.takePicture();

      // 사진을 영구적으로 저장
      final String savedPath = await _savePermanentPhoto(photo.path);

      // 촬영 상태 업데이트
      setState(() {
        _isCapturing = false;
        _captureStatus = "사진 저장 완료: $savedPath";
        _capturedImagePaths.add(savedPath);
      });

      // 다음 이미지 인덱스로 이동
      setState(() {
        if (_currentImageIndex < _maxImages) {
          _currentImageIndex++;
          _countdown = 10;
          _isCounting = true;
        } else {
          // 모든 사진 촬영 완료
          _moveToLoadingScreen();
        }
      });
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _captureStatus = "촬영 오류: $e";
      });
    }
  }

  Future<String> _savePermanentPhoto(String tempPath) async {
    try {
      // 현재 시간을 파일명에 포함시켜 고유한 파일명 생성
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filename = 'commit4cut_${_currentImageIndex}_$timestamp.jpg';
      final String destPath = path.join(_photoDirectory, filename);

      // 임시 파일을 영구 저장 위치로 복사
      final File tempFile = File(tempPath);
      final File savedFile = await tempFile.copy(destPath);

      print("사진 저장 완료: $destPath");

      return savedFile.path;
    } catch (e) {
      print("사진 저장 오류: $e");
      // 오류 발생 시 원본 경로 반환
      return tempPath;
    }
  }

  void _moveToLoadingScreen() {
    // 모든 사진 촬영이 완료되면 로딩 화면으로 이동
    Navigator.pushNamed(
      context,
      '/loading',
      arguments: {
        'designIndex': widget.index,
        'imagePaths': _capturedImagePaths,
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 카메라 미리보기
          if (_isCameraInitialized && _cameraController != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _cameraController!.value.previewSize!.height,
                  height: _cameraController!.value.previewSize!.width,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),

          // 카운트다운 표시
          if (_isCounting)
            Center(
              child: Text(
                '$_countdown',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // 사진 촬영 표시
          if (_isCapturing)
            Container(
              color: Colors.white.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
            ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _isCounting ? '카메라를 봐주세요!' : _captureStatus,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: CustomFontFamily.dohyeon,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            right: 50,
            child: Text(
              '$_currentImageIndex / $_maxImages',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
