class CustomFontFamily {
  /// 사용자 지정 폰트 패밀리입니다.
  ///
  /// 사용하려면 `fontFamily`에 `CustomFontFamily.<폰트이름>`을 입력하세요.
  ///
  /// 사용 예:
  /// ```dart
  /// Text(
  /// 'Hello, World!',
  /// style: TextStyle(
  ///   color: Colors.white,
  ///   fontSize: 60,
  ///   fontFamily: CustomFontFamily.hsyuji,
  ///   fontWeight: FontWeight.normal,
  /// ),
  /// ```
  ///
  /// 폰트를 추가하려면 `fonts` 폴더에 폰트를 추가하고
  /// `font.dart`, `pubsec.yaml`에 폰트 패밀리를 추가해야 합니다.
  ///
  /// font.dart 예시:
  /// ```dart
  /// static const hsyuji = "HSYuji";
  /// ```
  ///
  /// pubsec.yaml 예시:
  /// ```yaml
  /// flutter:
  ///   fonts:
  ///    - family: HSYuji
  ///      fonts:
  ///        - asset: fonts/HSYuji-Regular.ttf
  /// ```
  static const hsyuji = "HSYuji";
  static const dohyeon = "BMDOHYEON";
  static const hanna = "BMHANNA";
}
