import 'package:flutter/foundation.dart';

class AppEnv {
  // true kalau build RELEASE
  static bool get isProd => kReleaseMode;

  // true kalau DEBUG / PROFILE
  static bool get isDev => !kReleaseMode;
}
