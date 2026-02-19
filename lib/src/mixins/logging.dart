import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

import '../logger.dart';

mixin Logging {
  String get tag => '$runtimeType';

  @protected
  void log(message, {String? tag, LogLevel level = LogLevel.verbose, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: level, error: error, stack: stack, tag: tag ?? this.tag);

  @protected
  void warn(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: LogLevel.warning, error: error, stack: stack, tag: tag ?? this.tag);

  @protected
  void trace(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: LogLevel.verbose, error: error, stack: stack, tag: tag ?? this.tag);

  @protected
  void recordException(message, [Object? error, StackTrace? stack, String? tag, bool truncateMessage = true]) =>
      logMessage(message, level: LogLevel.error, error: error, stack: stack, tag: tag ?? this.tag);
}
