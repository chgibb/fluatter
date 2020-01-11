import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval abc-foo-bar from listing', () {
    var interpreter = interpreterFromListing(
        File("fixtures/5.2.4/foo-set-a.txt").readAsStringSync());

    interpreter.call("main");
    var upvalues = interpreter.upvalues;
    expect(upvalues, isNotNull);
    expect(upvalues[0]["a"], isNotNull);
    expect(upvalues[0]["a"], 0);

    interpreter.call("foo");
    upvalues = interpreter.upvalues;
    expect(upvalues, isNotNull);
    expect(upvalues[0]["a"], isNotNull);
    expect(upvalues[0]["a"], 1);
  });
}
