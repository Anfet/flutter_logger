import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('simple', () {
    logger.logMessage('test');
  });
}
