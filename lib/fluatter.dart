import 'dart:async';

import 'package:flutter/services.dart';

class Fluatter {
  static const MethodChannel _channel = const MethodChannel('fluatter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
