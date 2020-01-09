import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode closure =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  int B = registerConstants[1];
  StackFrame stackFrame = interpreter.stackFrames.last;

  stackFrame.registers[0] = interpreter.closures[B];
});
