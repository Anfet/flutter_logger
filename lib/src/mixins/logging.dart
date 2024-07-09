import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../logger.dart';

mixin Logging {
  @protected
  void log(message, {String? tag, Level level = Level.trace, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: level, tag: tag ?? "$runtimeType", error: error, stack: stack);

  @protected
  void warn(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: Level.warning, tag: tag ?? "$runtimeType", error: error, stack: stack);

  @protected
  void trace(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: Level.trace, tag: tag ?? "$runtimeType", error: error, stack: stack);

  @protected
  void recordException(message, [Object? error, StackTrace? stack, String? tag, bool truncateMessage = true]) =>
      logMessage(message, level: Level.error, tag: tag ?? "$runtimeType", error: error, stack: stack);
}
