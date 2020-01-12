import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/vm.dart';

OpCode $return =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  //int B = registerConstants[1];

  if (interpreter.stackFrames.length == 1 && interpreter.saveLastStackFrame) {
    return;
  }
  interpreter.stackFrames.removeLast();
});
