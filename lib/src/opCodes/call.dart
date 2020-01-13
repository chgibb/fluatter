import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:fluatter/src/util/observableMap.dart';
import 'package:fluatter/src/vm.dart';

OpCode $call =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  StackFrame stackFrame = interpreter.stackFrames.last;
  int A = registerConstants[0];
  int B = registerConstants[1];

  StackFrame newStackFrame = StackFrame(func: interpreter.R(A, stackFrame));

  newStackFrame.func.locals = ObservableMap.from(stackFrame.registers);

  newStackFrame.pc = -1;

  interpreter.stackFrames.add(newStackFrame);
});
