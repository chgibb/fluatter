import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/vm.dart';

OpCode $call =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];
  int C = registerConstants[2];

  StackFrame newStackFrame = StackFrame(func: interpreter.R(A, stackFrame));

  // if (B >= 2) {
  //   int numArgs = B - 1;
  //   for (var i = 0; i != numArgs; ++i) {
  //     newStackFrame.registers[i] =
  //         interpreter.stackFrames.last.registers[i + 1];
  //   }

  //   var truncRegisters = stackFrame.registers.keys.skip(A + 1).toList();
  //   for (var i = 0; i != truncRegisters.length; ++i) {
  //     newStackFrame.registers[i] = stackFrame.registers[truncRegisters[i]];
  //   }

  //   print(stackFrame.registers.keys.skip(A + 1).toList());

  //   print(newStackFrame.registers);
  //   print(interpreter.stackFrames.last.registers);
  // }

  print("Caller's registers: ${interpreter.stackFrames.last.registers}");

  if (B == 0) {
    for (var i = A + 1;
        i < interpreter.stackFrames.last.registers.keys.length;
        ++i) {
      newStackFrame.registers[i] = interpreter.stackFrames.last.registers[i];
    }
  } else {
    for (var i = 0; i < B - 1; ++i) {
      newStackFrame.registers[i] =
          interpreter.stackFrames.last.registers[A + i + 1];
    }
  }


  print("Callee's registers: ${newStackFrame.registers}");

  newStackFrame.pc = -1;

  interpreter.stackFrames.add(newStackFrame);
});
