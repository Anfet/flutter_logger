import 'package:flutter_logger/flutter_logger.dart';
import 'package:flutter_test/flutter_test.dart';

class X with Logging {

}

void main() {
  test('simple', () {
    var x = X();
    x.trace('verbose', );
    x.warn('warn');

  });
}
