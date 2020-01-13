import 'package:fluatter/src/func.dart';
import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode setabbup =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];
  int C = registerConstants[2];

  if (!(stackFrame.registers[0] is Func)) {
    interpreter.Upvalue(A, interpreter.stackFrames.last)[
            interpreter.RK(B, interpreter.stackFrames.last)] =
        interpreter.RK(C, interpreter.stackFrames.last);
  } else {
    (stackFrame.registers[0] as Func).name =
        interpreter.RK(B, interpreter.stackFrames.last);
  }
});
