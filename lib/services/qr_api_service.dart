import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class QRApiService {
  static const String baseUrl = 'https://port-0-backend-ysl2blowfnha3.sel5.cloudtype.app';
  
  /// API 서버 헬스 체크
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('헬스 체크 실패: $e');
      return false;
    }
  }

  /// URL QR 코드 생성 (주 사용 API)
  /// 이미지를 서버에 업로드하고 해당 URL을 QR 코드로 생성
  static Future<Uint8List?> generateUrlQRCode({
    required File imageFile,
    int boxSize = 12,
    int border = 4,
    String errorCorrection = 'M', // L, M, Q, H
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/qr/url');
      final request = http.MultipartRequest('POST', uri);
      
      // 이미지 파일 추가
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      
      // 옵션 매개변수 추가 (더 큰 QR 코드를 위해 boxSize 증가)
      request.fields['box_size'] = boxSize.toString();
      request.fields['border'] = border.toString();
      request.fields['error_correction'] = errorCorrection;
      
      final response = await request.send();
      
      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        final errorBody = await response.stream.bytesToString();
        print('URL QR 코드 생성 실패: ${response.statusCode} - $errorBody');
        return null;
      }
    } catch (e) {
      print('URL QR 코드 생성 중 오류: $e');
      return null;
    }
  }

  /// 업로드된 파일 가져오기
  static Future<Uint8List?> getUploadedFile(String filename) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/uploads/$filename'),
      );
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('파일 가져오기 실패: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('파일 가져오기 중 오류: $e');
      return null;
    }
  }
}
