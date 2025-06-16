import 'package:flutter/material.dart';
import 'package:commit4cut/style/font.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraTestPage extends StatefulWidget {
  final int designIndex;
  final int cellIndex;

  const CameraTestPage({super.key, this.designIndex = 0, this.cellIndex = 0});

  @override
  State<CameraTestPage> createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage> {
  int _countdown = 5; //사진 8초
  Timer? _timer;
  int _currentImageIndex = 1;
  final int _maxImages = 6; // 6장의 사진을 찍도록 수정
  bool _isCounting = true;
  bool _isCapturing = false;
  String _captureStatus = "";

  // 카메라 관련 변수
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  // 사진 저장 관련 변수
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

        // 카메라가 초기화된 후 추가 확인
        if (_cameraController!.value.previewSize == null) {
          print("경고: 카메라 프리뷰 크기가 null입니다!");
          setState(() {
            _captureStatus = "카메라 프리뷰를 불러올 수 없습니다.";
          });
          return;
        }

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
      print("카메라 초기화 오류: $e");
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
        timer.cancel(); // 마운트되지 않은 상태라면 타이머 취소
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.previewSize == null) {
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
          _countdown = 5;
          _isCounting = true;
        } else {
          // 모든 사진 촬영 완료
          _moveToNextScreen();
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

  void _moveToNextScreen() {
    // 모든 사진 촬영이 완료되면 다음 화면으로 이동
    Navigator.pushNamed(
      context,
      '/select_picture',
      arguments: {
        'designIndex': widget.designIndex,
        'cellIndex': widget.cellIndex,
        'photosPaths': _capturedImagePaths,
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('사진 촬영', style: TextStyle(color: Colors.white)),
        actions: [
          // 디버그 정보 보기 버튼
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('저장 정보'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('저장 경로: $_photoDirectory'),
                            const SizedBox(height: 10),
                            Text('촬영된 사진 수: ${_capturedImagePaths.length}'),
                            const SizedBox(height: 10),
                            if (_capturedImagePaths.isNotEmpty)
                              ...List.generate(
                                _capturedImagePaths.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    '${index + 1}: ${path.basename(_capturedImagePaths[index])}',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('닫기'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 카메라 미리보기
          if (_isCameraInitialized &&
              _cameraController != null &&
              _cameraController!.value.previewSize != null)
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

          // 카운트다운 오버레이
          if (_isCounting)
            Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                  ),
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

          // 하단 정보 표시
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _isCounting ? '카메라를 봐주세요!' : _captureStatus,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: CustomFontFamily.dohyeon,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$_currentImageIndex / $_maxImages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '촬영된 사진 수: ${_capturedImagePaths.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
