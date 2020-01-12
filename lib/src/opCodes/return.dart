import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/vm.dart';

OpCode $return =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  //int B = registerConstants[1];

  if (interpreter.stackFrames.length == 1 && interpreter.saveLastStackFrame) {
    return;
  }

  var priorFrame = interpreter.stackFrames.removeLast();

  var frame = interpreter.stackFrames.last;

  priorFrame.upvalues.keys.forEach((x) {
    print((priorFrame.upvalues[x]));
    (priorFrame.upvalues[x] as Map).keys.forEach((upvalue) {
      frame.upvalues[x][upvalue] = priorFrame.upvalues[x][upvalue];
    });
  });
});
