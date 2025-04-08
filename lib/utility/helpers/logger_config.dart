import 'package:flutter/foundation.dart';
import 'package:talker_logger/talker_logger.dart';

class AppLogFilter implements LoggerFilter {
  const AppLogFilter();

  @override
  bool shouldLog(dynamic msg, LogLevel level) => kDebugMode;
}

final logger = TalkerLogger(
  filter: const AppLogFilter(),
  formatter: const ColoredLoggerFormatter(),
);

void debugLog(dynamic msg) => logger.log('[log] $msg', level: LogLevel.info, pen: AnsiPen()..green());

void debugError(dynamic msg) => logger.log('[log] [Error] $msg', level: LogLevel.error);

void debugHttp({
  dynamic url,
  dynamic params,
  dynamic requests,
  HttpMethodType methodType = HttpMethodType.get,
}) {
  debugLog('[URL] ${methodType.logString} $url');

  debugLog('[PARAMS] $params');

  if (methodType == HttpMethodType.post) {
    debugLog('[REQUESTS] $requests');
  }
}

void debugResponse({dynamic body, int statusCode = 0}) {
  final prettyString = body;

  final msg = '[RESPONSE] [STATUS CODE] $statusCode [BODY] $prettyString';

  if (statusCode == 200) {
    debugLog(msg);
    return;
  }
  debugError(msg);
}

enum HttpMethodType {
  get('GET'),
  post('POST'),
  delete('DELETE');

  const HttpMethodType(this.name);
  final String name;

  String get logString => '[$name]';
}
