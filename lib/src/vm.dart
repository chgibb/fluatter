import 'package:fluatter/src/func.dart';
import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/opCodes/return.dart';
import 'package:fluatter/src/opCodes/settabup.dart';
import 'package:fluatter/src/stackFrame.dart';
import 'package:flutter/widgets.dart';

class Interpreter {
  Map<dynamic, dynamic> _globalSymbols = {};

  dynamic R(int i, StackFrame stackFrame) {
    return stackFrame.registers[i];
  }

  dynamic Kst(int n, Func func) => func.constants[n];
  dynamic Gbl(dynamic sym) => _globalSymbols[sym];
  dynamic Upvalue(dynamic n, StackFrame stackFrame) => stackFrame.upvalues[n];
  dynamic RK(int i, StackFrame stackFrame) => stackFrame.registers[i] != null
      ? stackFrame.registers[i]
      : Kst(i, stackFrame.func) != null ? Kst(i, stackFrame.func) : Gbl(i);

  Map<String, OpCode> _opcodes = {};

  Func mainFunc;

  @visibleForTesting
  Map<String, Func> closures = {};

  List<StackFrame> stackFrames = [];

  void addClosure(Func func) {
    closures[func.name] = func;
  }

  //https://the-ravi-programming-language.readthedocs.io/en/latest/lua_bytecode_reference.html
  Interpreter() {
    _opcodes["SETTABUP"] = setabbup;

    _opcodes["RETURN"] = $return;
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
    stackFrames.add(
        StackFrame(func: funcName != "main" ? closures[funcName] : mainFunc));
    exec(saveLastFrame: saveLastFrame);
  }
}
