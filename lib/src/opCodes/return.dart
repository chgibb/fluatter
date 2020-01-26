import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/vm.dart';

OpCode $return =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  int A = registerConstants[0];
  int B = registerConstants[1];

  if (interpreter.stackFrames.length == 1 && interpreter.saveLastStackFrame) {
    return;
  }

  var priorFrame = interpreter.stackFrames.removeLast();

  var frame = interpreter.stackFrames.last;

  print("Callee's registers ${priorFrame.registers}");
  print("Caller's registers: ${frame.registers}");

  if (B == 0) {
    // var carryOverKeys = priorFrame.registers.keys.toList();
    for (var i = A; i < priorFrame.registers.keys.length; ++i) {
      frame.registers[i] = priorFrame.registers[i];
    }
  } else {
    for (var i = 0; i < B - 1; ++i) {
      frame.registers[i] = priorFrame.registers[A + i];
    }
  }

  print("Caller's registers after carryover: ${frame.registers}");

  // var carryOverKeys = priorFrame.registers.keys.take(B - 1).toList();
  // Map<int, dynamic> carryOverRegisters = {};

  // carryOverKeys.forEach((x) {
  //   carryOverRegisters[x] = priorFrame.registers[x];
  // });

  // if (carryOverRegisters.isNotEmpty) {
  //   for (var i = 0; i != carryOverRegisters.length; ++i) {
  //     frame.registers[A + i] = carryOverRegisters[i];
  //   }
  // }

  // print("Callee's registers ${priorFrame.registers}");
  // print("Carryover registers: $carryOverRegisters");
  // print("Caller's registers: ${frame.registers}");

  priorFrame.upvalues.keys.forEach((x) {
    // print((priorFrame.upvalues[x]));
    (priorFrame.upvalues[x] as Map).keys.forEach((upvalue) {
      frame.upvalues[x][upvalue] = priorFrame.upvalues[x][upvalue];
    });
  });
});
