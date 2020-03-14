import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/**
 * 打印日志，外部可以控制日历信息的打印显示，方便调试查错
 */
class LogUtil {
  static bool _enableLog = false; //是否可以打印日志

  static set enableLog(bool value) {
    _enableLog = value;
  }

  /**
   * TAG:类名
   * message：一般就方法名+自定义信息吧
   */
  static void log({@required dynamic TAG, String message = ""}) {
    if (_enableLog && kDebugMode) {
      debugPrint("flutter_custom_calendar------$TAG------>$message");
    }
  }
}
