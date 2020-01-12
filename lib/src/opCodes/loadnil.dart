import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode loadnil =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;

  int A = registerConstants[0];
  int B = registerConstants[1];

  for (var i = A; i != A + B + 1; ++i) {
    stackFrame.registers[i] = null;
  }
});
