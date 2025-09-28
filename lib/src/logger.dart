import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_logger/src/simple_logger_formatter.dart';
import 'package:talker/talker.dart';

const _appTag = 'APP';
const _maxCharactersPerLog = 700;
final _splitter = RegExp('.{1,$_maxCharactersPerLog}');

TalkerLoggerSettings defaultLoggerSettings = TalkerLoggerSettings(
  lineSymbol: '',
  maxLineWidth: _maxCharactersPerLog,
  defaultTitle: _appTag,
  colors: {
    LogLevel.verbose: AnsiPen()..black(),
    LogLevel.debug: AnsiPen()..black(),
    LogLevel.info: AnsiPen()..blue(),
    LogLevel.warning: AnsiPen()..yellow(),
    LogLevel.error: AnsiPen()..red(),
    LogLevel.critical: AnsiPen()..red(),
  },
);

TalkerSettings defaultTalkerSettings = TalkerSettings(
  useHistory: kDebugMode,
  enabled: kDebugMode,
  colors: {
    ...defaultLoggerSettings.colors.map((key, value) => MapEntry(key.name, value)),
  },
  titles: {
    for (final e in LogLevel.values) e.name: _appTag,
  },
);

Talker _logger = Talker(
  settings: defaultTalkerSettings,
  logger: TalkerLogger(
    formatter: SimpleLoggerFormatter(),
    settings: defaultLoggerSettings,
  ),
);

Talker get logger => _logger;

set installGlobalLogger(Talker value) => _logger = value;

void logMessage(message, {String? tag, LogLevel level = LogLevel.verbose, Object? error, StackTrace? stack, bool truncateMessage = true}) =>
    logger._logMessage(message, level: level, error: error, stack: stack, tag: tag);

extension on Talker {
  void _logMessage(
    message, {
    String? tag,
    LogLevel level = LogLevel.verbose,
    Object? error,
    StackTrace? stack,
    bool truncateMessage = true,
  }) {
    var text = '$message';

    final penByLogKey = settings.getPenByKey(level.name);
    final title = tag ?? settings.getTitleByKey(level.name);

    if (truncateMessage == true) {
      var rawTextLength = text.length;
      text = text.toString().substring(0, min(text.length, _maxCharactersPerLog));
      var lenDif = rawTextLength - text.length;
      var log = "$text ${lenDif > 0 ? ' ...(+$lenDif chars)' : ''}";

      logCustom(SimpleLog(log, logLevel: level, title: title, exception: error, stackTrace: stack, pen: penByLogKey));
    } else {
      var texts = _splitter.allMatches(text).map((match) => match[0] ?? '').toList();
      if (texts.isNotEmpty) {
        var start = texts.removeAt(0);
        logCustom(SimpleLog(start, logLevel: level, title: title, exception: error, stackTrace: stack, pen: penByLogKey));
      }

      for (var text in texts) {
        logCustom(SimpleLog(text, logLevel: level, title: title, exception: error, stackTrace: stack, pen: penByLogKey));
      }
    }
  }
}
