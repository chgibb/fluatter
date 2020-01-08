import 'package:fluatter/src/func.dart';
import 'package:flutter/foundation.dart';

class StackFrame {
  final Func func;
  final Map<int, dynamic> _upvalues;

  Map<int, dynamic> get upvalues => _upvalues;

  StackFrame({@required this.func}) : _upvalues = Map.from(func.upvalues);
}
