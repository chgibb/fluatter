import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode closure = OpCode(exec: (int A, int B, int C, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;

  stackFrame.registers[0] = interpreter.closures[B];
});
