import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:fluatter/src/func.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval abc from listing', () {
    var interpreter =
        interpreterFromListing(File("fixtures/5.2.4/abc.txt").readAsStringSync());

    Func mainFunc = interpreter.mainFunc;

    expect(mainFunc, isNotNull);
    expect(mainFunc.name, "main");
    expect(mainFunc.slots, 2);
    expect(mainFunc.numupvalues, 1);
    expect(mainFunc.numlocals, 0);
    expect(mainFunc.numconstants, 6);
    expect(mainFunc.functions, 0);
    expect(mainFunc.instructionStream.length, 4);

    expect(mainFunc.instructionStream[0].name, "SETTABUP");
    expect(mainFunc.instructionStream[0].registerConstants[0], 0);
    expect(mainFunc.instructionStream[0].registerConstants[1], -1);
    expect(mainFunc.instructionStream[0].registerConstants[2], -2);

    expect(mainFunc.instructionStream[1].name, "SETTABUP");
    expect(mainFunc.instructionStream[1].registerConstants[0], 0);
    expect(mainFunc.instructionStream[1].registerConstants[1], -3);
    expect(mainFunc.instructionStream[1].registerConstants[2], -4);

    expect(mainFunc.instructionStream[2].name, "SETTABUP");
    expect(mainFunc.instructionStream[2].registerConstants[0], 0);
    expect(mainFunc.instructionStream[2].registerConstants[1], -5);
    expect(mainFunc.instructionStream[2].registerConstants[2], -6);

    expect(mainFunc.instructionStream[3].name, "RETURN");
    expect(mainFunc.instructionStream[3].registerConstants[0], 0);
    expect(mainFunc.instructionStream[3].registerConstants[1], 1);
    expect(mainFunc.instructionStream[3].registerConstants[2], 0);

    interpreter.call("main", saveLastFrame: true);

    expect(interpreter.stackFrames.length, 1);
    expect(interpreter.stackFrames[0].func.upvalues[0]["a"], 1);
    expect(interpreter.stackFrames[0].func.upvalues[0]["b"], 2);
    expect(interpreter.stackFrames[0].func.upvalues[0]["c"], 3);
  }, timeout: Timeout(Duration(minutes: 10)));
}
