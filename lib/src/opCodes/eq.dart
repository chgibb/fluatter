import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode eq =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];
  int C = registerConstants[2];

  var l = stackFrame.registers[B];
  var r = interpreter.Kst(C.abs(), stackFrame.func);

  if ((l == r) != (A == 0 ? false : true)) {
    stackFrame.pc++;
  }
});
