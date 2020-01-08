import 'package:fluatter/src/lua.dart';
import 'package:flutter/foundation.dart';

class OpCode {
  final void Function(int, int, int, Interpreter) exec;

  OpCode({@required this.exec});
}