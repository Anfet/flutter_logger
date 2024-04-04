import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:siberian_logger/siberian_logger.dart';
import 'package:sprintf/sprintf.dart';

const appTag = 'APP';
const _maxCharactersPerLog = 800;
final _splitter = RegExp('.{80,$_maxCharactersPerLog}');
final _dateFormatter = DateFormat("Hms");
const _tagAction = ":";
const _encoder = JsonEncoder.withIndent(null);

Logger logger = Logger(
  printer: CustomLogger(
    truncateMessages: true,
    isEnabled: true,
  ),
);

void installLogger(Logger value) {
  logger = value;
}

class CustomLogger extends LogPrinter {
  final bool isColored;
  bool truncateMessages;
  bool isEnabled;

  final String Function(String)? messageTransformer;

  CustomLogger({
    this.truncateMessages = true,
    this.isEnabled = true,
    this.messageTransformer,
    this.isColored = false,
  }) : super();

  @override
  List<String> log(LogEvent event) {
    if (!isEnabled) {
      return [];
    }

    final messageStr = _stringifyMessage(event.message);
    final errorStr = event.error != null ? '\n${event.error}' : '';
    final now = DateTime.now();
    final time = _dateFormatter.format(now);
    final msec = sprintf("%03i", [now.millisecond]);
    final timeStr = "$time.$msec";
    final traceStr = event.stackTrace == null ? "" : "\n${event.stackTrace}";
    final label = _labelFor(event.level);
    var text = '$timeStr $label $messageStr$errorStr$traceStr';
    text = messageTransformer?.call(text) ?? text;

    if (truncateMessages) {
      text = text.substring(0, min(text.length, _maxCharactersPerLog));
    }

    final result = _splitter.allMatches(text).map((match) => match[0] ?? '').toList();
    return result;
  }

  String _labelFor(Level level) {
    var prefix = SimplePrinter.levelPrefixes[level]!;
    if (isColored) {
      final color = SimplePrinter.levelColors[level]!;
      return color(prefix);
    }

    return prefix;
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      return _encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}

mixin Logging {
  void log(message, {String? tag, Level level = Level.trace, Object? error, StackTrace? stack}) =>
      logMessage(message, level: level, tag: tag ?? "$runtimeType", error: error, stack: stack);

  void warn(message, {String? tag, Object? error, StackTrace? stack}) =>
      logMessage(message, level: Level.warning, tag: tag ?? "$runtimeType", error: error, stack: stack);

  void trace(message, {String? tag, Object? error, StackTrace? stack}) =>
      logMessage(message, level: Level.trace, tag: tag ?? "$runtimeType", error: error, stack: stack);

  void error(message, [Object? error, StackTrace? stack, String? tag]) =>
      logMessage(message, level: Level.error, tag: tag ?? "$runtimeType", error: error, stack: stack);
}

void logMessage(message, {String? tag = appTag, Level level = Level.trace, Object? error, StackTrace? stack}) =>
    logger.log(level, "$tag$_tagAction $message", error: error, stackTrace: stack);

void warn(message, {String? tag, Object? error, StackTrace? stack}) =>
    logMessage(message, level: Level.warning, tag: tag, error: error, stack: stack);

void trace(message, {String? tag, Object? error, StackTrace? stack}) => logMessage(message, level: Level.trace, tag: tag, error: error, stack: stack);

void recordException(message, [String? tag, Object? error, StackTrace? stack]) =>
    logMessage(message, level: Level.error, tag: tag, error: error, stack: stack);
