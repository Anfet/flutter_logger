import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_logger/src/simple_logger_formatter.dart';
import 'package:talker/talker.dart';

const _appTag = 'APP';
const _maxCharactersPerLog = 700;
final _splitter = RegExp('.{1,$_maxCharactersPerLog}');
const _tagAction = ":";

TalkerLoggerSettings defaultLoggerSettings = TalkerLoggerSettings(
  lineSymbol: '',
  maxLineWidth: 700,
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


extension LoggerFuncExt on Talker {
  void logMessage(
    message, {
    String? tag = _appTag,
    LogLevel level = LogLevel.verbose,
    Object? error,
    StackTrace? stack,
    bool truncateMessage = true,
  }) {
    var text = '$message';

    if (truncateMessage == true) {
      var rawTextLength = text.length;
      text = text.toString().substring(0, min(text.length, _maxCharactersPerLog));
      var lenDif = rawTextLength - text.length;
      this.log("$text ${lenDif > 0 ? ' ...(+$lenDif chars)' : ''}", logLevel: level, exception: error, stackTrace: stack);
    } else {
      var texts = _splitter.allMatches(text).map((match) => match[0] ?? '').toList();
      if (texts.isNotEmpty) {
        var start = '${texts.removeAt(0)}';
        this.log(start, logLevel: level, exception: error, stackTrace: stack);
      }

      for (var text in texts) {
        this.log(text, logLevel: level, exception: error, stackTrace: stack);
      }
    }
  }
}
