import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval simple-factorial', () {
    var interpreter = interpreterFromListing(
        File("fixtures/5.2.4/simple-factorial.txt").readAsStringSync());

    interpreter.call("main");
  }, timeout: Timeout(Duration(minutes: 10)));
}
