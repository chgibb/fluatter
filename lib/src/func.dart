import 'package:fluatter/src/instruction.dart';
import 'package:fluatter/src/util/observableMap.dart';
import 'package:flutter/foundation.dart';

class Func {
  String name;
  final int params;
  final int slots;
  final int numupvalues;
  final int numlocals;
  final int numconstants;
  final int functions;

  final List<Instruction> instructionStream;

  final Map<int, dynamic> upvalues;
  final Map<int, dynamic> constants;
  ObservableMap<int, dynamic> locals;

  Func(
      {@required this.name,
      @required this.params,
      @required this.slots,
      @required this.numupvalues,
      @required this.numlocals,
      @required this.numconstants,
      @required this.functions,
      @required this.instructionStream,
      @required this.upvalues,
      @required this.constants,
      @required this.locals});
}
