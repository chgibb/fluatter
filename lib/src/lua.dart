import 'package:flutter/widgets.dart';

class Interpreter {
  Map<dynamic, dynamic> _registers = {};
  Map<dynamic, dynamic> _constants = {};
  Map<dynamic, dynamic> _globalSymbols = {};
  Map<dynamic, dynamic> _upvalues = {};

  dynamic R(dynamic i) => _registers[i];
  dynamic Kst(dynamic n) => _constants[n];
  dynamic Gbl(dynamic sym) => _globalSymbols[sym];
  dynamic Upvalue(dynamic n) => _upvalues[n];
  dynamic RK(dynamic i) => _registers[i] != null ? _registers[i] : Gbl(i);

  Map<String, OpCode> _opcodes = {};

  @visibleForTesting
  Map<String, Func> functions = {};

  void addFunction(Func func) {
    functions[func.name] = func;
  }

  Interpreter() {
    _opcodes["SETABBUP"] =
        OpCode(exec: (int A, int B, int C, Interpreter interpreter) {
      interpreter.Upvalue(A)[interpreter.RK(B)] = interpreter.RK(C);
    });

    _opcodes["RETURN"] =
        OpCode(exec: (int A, int B, int C, Interpreter interpreter) {});
  }
}

class OpCode {
  final void Function(int, int, int, Interpreter) exec;

  OpCode({@required this.exec});
}

class Instruction {
  final String name;
  final int A;
  final int B;
  final int C;

  Instruction(
      {@required this.name,
      @required this.A,
      @required this.B,
      @required this.C});
}

class Func {
  final String name;
  final int params;
  final int slots;
  final int upvalues;
  final int locals;
  final int constants;
  final int functions;

  final List<Instruction> instructionStream;

  Func(
      {@required this.name,
      @required this.params,
      @required this.slots,
      @required this.upvalues,
      @required this.locals,
      @required this.constants,
      @required this.functions,
      @required this.instructionStream});
}
