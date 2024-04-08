import 'package:logger/logger.dart';
import 'package:siberian_logger/src/logger.dart';

mixin Logging {

  void log(message, {String? tag, Level level = Level.trace, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: level, tag: tag ?? "$runtimeType", error: error, stack: stack);

  void warn(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: Level.warning, tag: tag ?? "$runtimeType", error: error, stack: stack);

  void trace(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      logMessage(message, level: Level.trace, tag: tag ?? "$runtimeType", error: error, stack: stack);

  void error(message, [Object? error, StackTrace? stack, String? tag, bool truncateMessage = true]) =>
      logMessage(message, level: Level.error, tag: tag ?? "$runtimeType", error: error, stack: stack);
}
