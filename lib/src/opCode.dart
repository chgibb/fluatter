import 'package:fluatter/src/vm.dart';
import 'package:flutter/foundation.dart';

class OpCode {
  final void Function(List<int>, Interpreter) exec;

  OpCode({@required this.exec});
}
