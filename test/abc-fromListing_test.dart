import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:fluatter/src/lua.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval abc from listing', () {
    /*
        ;Original file:
        a = 1
        b = 2
        c = 3
    */
    var interpreter =
        interpreterFromListing(File("fixtures/abc.txt").readAsStringSync());

    Func mainFunc = interpreter.functions["main"];

    expect(mainFunc, isNotNull);
    expect(mainFunc.name, "main");
    expect(mainFunc.slots, 2);
    expect(mainFunc.numupvalues, 1);
    expect(mainFunc.locals, 0);
    expect(mainFunc.constants, 6);
    expect(mainFunc.functions, 0);
    expect(mainFunc.instructionStream.length, 4);

    expect(mainFunc.instructionStream[0].name, "SETTABUP");
    expect(mainFunc.instructionStream[0].A, 0);
    expect(mainFunc.instructionStream[0].B, -1);
    expect(mainFunc.instructionStream[0].C, -2);

    expect(mainFunc.instructionStream[1].name, "SETTABUP");
    expect(mainFunc.instructionStream[1].A, 0);
    expect(mainFunc.instructionStream[1].B, -3);
    expect(mainFunc.instructionStream[1].C, -4);

    expect(mainFunc.instructionStream[2].name, "SETTABUP");
    expect(mainFunc.instructionStream[2].A, 0);
    expect(mainFunc.instructionStream[2].B, -5);
    expect(mainFunc.instructionStream[2].C, -6);

    expect(mainFunc.instructionStream[3].name, "RETURN");
    expect(mainFunc.instructionStream[3].A, 0);
    expect(mainFunc.instructionStream[3].B, 1);
    expect(mainFunc.instructionStream[3].C, 0);

    interpreter.call("main", saveLastFrame: true);

    expect(interpreter.stackFrames.length, 1);
    expect(interpreter.stackFrames[0].func.upvalues[0]["a"], 1);
  });
}
