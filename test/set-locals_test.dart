import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval simple-factorial', () {
    var interpreter = interpreterFromListing(
        File("test/fixtures/5.2.4/set-locals.txt").readAsStringSync());

    interpreter.call("main");
    expect(interpreter.upvalues[0]["d"], 4);

    expect(interpreter.findFuncByName("foo"), isNotNull);

    interpreter.call("foo");
    expect(interpreter.stackFrames.last.registers[0], 1);
    expect(interpreter.stackFrames.last.registers[1], 2);
    expect(interpreter.stackFrames.last.registers[2], 2);
    expect(interpreter.upvalues[0]["d"], 4);
  }, timeout: Timeout(Duration(minutes: 10)));
}
