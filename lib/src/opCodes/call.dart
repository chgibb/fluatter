import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode $call =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];

  StackFrame newStackFrame = StackFrame(func: interpreter.R(A, stackFrame));
  newStackFrame.registers[A] = newStackFrame.func;
  if (B >= 2) {
    int i = 0;
    while (i != B - 1) {
      newStackFrame.registers[i] = stackFrame.registers[i + 1];
      i++;
    }
  }

  newStackFrame.pc = -1;

  interpreter.stackFrames.add(newStackFrame);
});
