import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sprintf/sprintf.dart';

const appTag = 'APP';
const _maxCharactersPerLog =700;
final _splitter = RegExp('.{1,$_maxCharactersPerLog}');
final _dateFormatter = DateFormat("Hms");
const _tagAction = ":";
const _encoder = JsonEncoder.withIndent(null);

Logger logger = Logger(
  printer: CustomLogger(
    isEnabled: true,
  ),
);

void installLogger(Logger value) {
  logger = value;
}

class CustomLogger extends LogPrinter {
  final bool isColored;
  bool isEnabled;

  final String Function(String)? messageTransformer;

  CustomLogger({
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

    return [text];
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

void logMessage(message, {String? tag = appTag, Level level = Level.trace, Object? error, StackTrace? stack, bool truncateMessage = true}) {
  var text= '$message';
  if (truncateMessage == true) {
    text = text.toString().substring(0, min(text.length, _maxCharactersPerLog));
    logger.log(level, "$tag$_tagAction $message", error: error, stackTrace: stack);
  } else {
    var texts = _splitter.allMatches(text).map((match) => match[0] ?? '').toList();
    var start = '$tag$_tagAction ${texts.removeAt(0)}';
    logger.log(level, start, error: error, stackTrace: stack);
    for (var text in texts) {
      logger.log(level, text, error: error, stackTrace: stack);
    }
  }

}
