import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval abc-foo-bar from listing', () {
    var interpreter = interpreterFromListing(
        File("fixtures/5.2.4/abc-foo-bar.txt").readAsStringSync());

    var mainFunc = interpreter.mainFunc;
    expect(mainFunc, isNotNull);
    expect(mainFunc.constants.length, 3);
    expect(mainFunc.constants[0], null);
    expect(mainFunc.constants[1], "foo");
    expect(mainFunc.constants[2], "bar");

    var foo = interpreter.findFuncByName("0x55566bee9990");
    expect(foo, isNotNull);
    expect(foo.constants.length, 4);
    expect(foo.constants[0], null);
    expect(foo.constants[1], 1);
    expect(foo.constants[2], 2);
    expect(foo.constants[3], 3);

    var bar = interpreter.findFuncByName("0x55566bee9fe0");
    expect(bar, isNotNull);
    expect(bar.constants.length, 4);
    expect(bar.constants[0], null);
    expect(bar.constants[1], 1);
    expect(bar.constants[2], 2);
    expect(bar.constants[3], 3);
    interpreter.call("main");

    expect(foo.name, "foo");
    expect(bar.name, "bar");

    var res = interpreter.call("foo", saveLastFrame: true);
    expect(res, null);
    expect(interpreter.stackFrames.last.registers[0], 1);
    expect(interpreter.stackFrames.last.registers[1], 2);
    expect(interpreter.stackFrames.last.registers[2], 3);
    interpreter.stackFrames.removeLast();

    res = interpreter.call("bar", saveLastFrame: true);
    expect(res, null);
    expect(interpreter.stackFrames.last.registers[0], 1);
    expect(interpreter.stackFrames.last.registers[1], 2);
    expect(interpreter.stackFrames.last.registers[2], 3);
    interpreter.stackFrames.removeLast();
  });
}
