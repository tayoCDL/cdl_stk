import 'package:flutter/foundation.dart';

class Environment {
  static String get fileName => kReleaseMode ? ".env.production" : ".env.development";
//  static String get apiUrl => dotenv.env['API_URL'] ?? 'MY_FALLBACK';
}