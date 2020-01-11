import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode gettabup =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];
  int C = registerConstants[2];

  var val = interpreter.Upvalue(
      B.abs(), stackFrame)[interpreter.RK(C.abs(), stackFrame)];

  if (val == null) {
    val = interpreter.RK(C.abs(), stackFrame);
  }

  if (val is String) {
    var func = interpreter.findFuncByName(val);
    //Load closure into register A by name
    if (func != null) {
      stackFrame.registers[A] = func;
      return;
    }
  }

  stackFrame.registers[A] = interpreter.Upvalue(
      B.abs(), stackFrame)[interpreter.RK(C.abs(), stackFrame)];
});
