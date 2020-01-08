import 'package:flutter/widgets.dart';

class Interpreter {
  Map<dynamic, dynamic> _registers = {};
  Map<dynamic, dynamic> _constants = {};
  Map<dynamic, dynamic> _globalSymbols = {};

  dynamic R(dynamic i) => _registers[i];
  dynamic Kst(dynamic n) => _constants[n];
  dynamic Gbl(dynamic sym) => _globalSymbols[sym];
  dynamic Upvalue(dynamic n, StackFrame stackFrame) => stackFrame._upvalues[n];
  dynamic RK(dynamic i) => _registers[i] != null ? _registers[i] : Gbl(i);

  Map<String, OpCode> _opcodes = {};

  @visibleForTesting
  Map<String, Func> functions = {};

  @visibleForTesting
  List<StackFrame> stackFrames = [];

  void addFunction(Func func) {
    functions[func.name] = func;
  }

  //https://the-ravi-programming-language.readthedocs.io/en/latest/lua_bytecode_reference.html
  Interpreter() {
    _opcodes["SETTABUP"] =
        OpCode(exec: (int A, int B, int C, Interpreter interpreter) {
      _registers = {A: A, B: _constants[B.abs()], C: _constants[C.abs()]};

      print(_registers);

      interpreter.Upvalue(A, interpreter.stackFrames.last)[interpreter.RK(B)] =
          interpreter.RK(C);
    });

    _opcodes["RETURN"] =
        OpCode(exec: (int A, int B, int C, Interpreter interpreter) {});
  }

  void exec({bool saveLastFrame = false}) {
    while (stackFrames.isNotEmpty) {
      stackFrames.last.func.instructionStream
          .forEach((x) => _opcodes[x.name].exec(x.A, x.B, x.C, this));

      if (stackFrames.length == 1 && saveLastFrame) {
        return;
      }

      stackFrames.removeLast();
    }
  }

  void call(String funcName, {bool saveLastFrame = false}) {
    stackFrames.add(StackFrame(func: functions[funcName]));
    exec(saveLastFrame: saveLastFrame);
  }
}

class StackFrame {
  final Func func;
  final Map<int, dynamic> _upvalues;

  StackFrame({@required this.func}) : _upvalues = Map.from(func.upvalues);
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
  final int numupvalues;
  final int locals;
  final int constants;
  final int functions;

  final List<Instruction> instructionStream;

  final Map<int, dynamic> upvalues;

  Func(
      {@required this.name,
      @required this.params,
      @required this.slots,
      @required this.numupvalues,
      @required this.locals,
      @required this.constants,
      @required this.functions,
      @required this.instructionStream,
      @required this.upvalues});
}
