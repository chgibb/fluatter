import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval simple-factorial', () {
    var interpreter = interpreterFromListing(
        File("test/fixtures/5.2.4/set-locals.txt").readAsStringSync());

    interpreter.call("main");

    expect(interpreter.findFuncByName("foo"), isNotNull);
    expect(interpreter.upvalues[0]["d"], 4);
  }, timeout: Timeout(Duration(minutes: 10)));
}
