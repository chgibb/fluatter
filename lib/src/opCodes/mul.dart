import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode mul =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];
  int C = registerConstants[2];

  var l = interpreter.RK(B, stackFrame);

  var r = interpreter.RK(C, stackFrame);

  print("Multiplied $l x $r");

  stackFrame.registers[A] = l * r;
});
