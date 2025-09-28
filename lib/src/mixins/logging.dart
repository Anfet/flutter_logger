import 'package:flutter/foundation.dart';
import 'package:flutter_logger/src/simple_logger_formatter.dart';
import 'package:talker/talker.dart';

import '../logger.dart';

mixin Logging {
  String get _TAG => '$runtimeType';

  late final _mixinlogger = Talker(
    logger: TalkerLogger(
      formatter: SimpleLoggerFormatter(),
      settings: defaultLoggerSettings.copyWith(
        defaultTitle: _TAG,
      ),
    ),
    settings: logger.settings.copyWith(
      titles: Map.fromEntries(
        LogLevel.values.map((e) => MapEntry(e.name, _TAG)),
      ),
    ),
  );

  @protected
  void log(message, {String? tag, LogLevel level = LogLevel.verbose, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      _mixinlogger.logMessage(message, level: level, tag: tag ?? "$runtimeType", error: error, stack: stack);

  @protected
  void warn(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      _mixinlogger.logMessage(message, level: LogLevel.warning, tag: tag ?? "$runtimeType", error: error, stack: stack);

  @protected
  void trace(message, {String? tag, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
      _mixinlogger.logMessage(message, level: LogLevel.verbose, tag: tag ?? "$runtimeType", error: error, stack: stack);

  @protected
  void recordException(message, [Object? error, StackTrace? stack, String? tag, bool truncateMessage = true]) =>
      _mixinlogger.logMessage(message, level: LogLevel.error, tag: tag ?? "$runtimeType", error: error, stack: stack);
}
