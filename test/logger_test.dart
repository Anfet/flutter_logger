import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_test/flutter_test.dart';

class X with Logging {
  void logVerbose(String message) => trace(message);
  void logWarning(String message) => warn(message);
}

void main() {
  test('simple', () {
    final x = X();
    expect(() => x.logVerbose('verbose'), returnsNormally);
    expect(() => x.logWarning('warn'), returnsNormally);
  });
}
