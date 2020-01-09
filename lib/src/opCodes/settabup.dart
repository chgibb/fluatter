import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode setabbup = OpCode(exec: (int A, int B, int C, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;

  stackFrame.registers[1] = interpreter.Kst(B.abs(), stackFrame.func);
  stackFrame.registers[2] = interpreter.Kst(C.abs(), stackFrame.func);

  interpreter.Upvalue(A, interpreter.stackFrames.last)[
          interpreter.RK(B.abs(), interpreter.stackFrames.last)] =
      interpreter.RK(C.abs(), interpreter.stackFrames.last);
});
