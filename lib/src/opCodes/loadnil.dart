import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/vm.dart';

OpCode loadnil =
    OpCode(exec: (List<int> registerConstants, Interpreter interpreter) {
  int A = registerConstants[0];
  int B = registerConstants[1];
});
