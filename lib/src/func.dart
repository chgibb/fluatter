import 'package:fluatter/src/instruction.dart';
import 'package:flutter/foundation.dart';

class Func {
  final String name;
  final int params;
  final int slots;
  final int numupvalues;
  final int locals;
  final int numconstants;
  final int functions;

  final List<Instruction> instructionStream;

  final Map<int, dynamic> upvalues;
  final Map<int, dynamic> constants;

  Func(
      {@required this.name,
      @required this.params,
      @required this.slots,
      @required this.numupvalues,
      @required this.locals,
      @required this.numconstants,
      @required this.functions,
      @required this.instructionStream,
      @required this.upvalues,
      @required this.constants});
}
