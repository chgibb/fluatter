import 'package:fluatter/src/func.dart';
import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:flutter/widgets.dart';

class Interpreter {
  Map<dynamic, dynamic> _registers = {};
  Map<dynamic, dynamic> _constants = {};
  Map<dynamic, dynamic> _globalSymbols = {};

  dynamic R(dynamic i) => _registers[i];
  dynamic Kst(dynamic n) => _constants[n];
  dynamic Gbl(dynamic sym) => _globalSymbols[sym];
  dynamic Upvalue(dynamic n, StackFrame stackFrame) => stackFrame.upvalues[n];
  dynamic RK(dynamic i) => _registers[i] != null ? _registers[i] : Gbl(i);

  Map<String, OpCode> _opcodes = {};

  @visibleForTesting
  Map<String, Func> functions = {};

  @visibleForTesting
  List<StackFrame> stackFrames = [];

  void writeConstant(int key, dynamic val) {
    _constants[key] = val;
  }

  void addFunction(Func func) {
    functions[func.name] = func;
  }

  //https://the-ravi-programming-language.readthedocs.io/en/latest/lua_bytecode_reference.html
  Interpreter() {
    _opcodes["SETTABUP"] =
        OpCode(exec: (int A, int B, int C, Interpreter interpreter) {
      _registers = {A: A, B: _constants[B.abs()], C: _constants[C.abs()]};

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
