import 'package:flutter/foundation.dart';

class Baseurl {
  static String get base {
    // Web (Chrome, Edge, etc.)
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    // Mobile / Desktop
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api'; // Android Emulator
      case TargetPlatform.iOS:
        return 'http://127.0.0.1:8000/api'; // iOS Simulator
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://127.0.0.1:8000/api';
      default:
        return 'http://127.0.0.1:8000/api';
    }
  }
}
