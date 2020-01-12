import 'package:fluatter/src/func.dart';
import 'package:flutter/foundation.dart';

class StackFrame {
  final Func func;
  final Map<int, dynamic> _upvalues;
  int pc = 0;
  Map<int, dynamic> registers = {};

  Map<int, dynamic> get upvalues => _upvalues;

  StackFrame({@required this.func}) : _upvalues = Map.from(func.upvalues) {
    for (var i = 0; i != func.locals.length; ++i) {
      registers[i] = func.locals[i];
    }
  }
}
