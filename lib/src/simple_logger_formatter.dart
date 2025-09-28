import 'package:flutter_logger/flutter_logger.dart';

class SimpleLoggerFormatter extends LoggerFormatter {
  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final msg = details.message?.toString() ?? '';
    if (!settings.enableColors) {
      return msg;
    }
    var lines = msg.split('\n');
    lines = lines.map((e) => details.pen.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }
}

class SimpleLog extends TalkerLog {
  SimpleLog(super.message, {super.key, super.title, super.exception, super.error, super.stackTrace, super.time, super.pen, super.logLevel});

  @override
  String generateTextMessage({TimeFormat timeFormat = TimeFormat.timeAndSeconds}) {
    final timeStr = sprintf('%02i:%02i:%02i.%03i', [time.hour, time.minute, time.second, time.millisecond]);

    return '$timeStr [${(logLevel ?? LogLevel.verbose).name.toUpperCase().substring(0, 1)}] $title: $displayMessage$displayException$displayStackTrace';
  }
}
