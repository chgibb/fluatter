import 'package:fluatter/src/func.dart';
import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/opCodes/closure.dart';
import 'package:fluatter/src/opCodes/loadk.dart';
import 'package:fluatter/src/opCodes/return.dart';
import 'package:fluatter/src/opCodes/settabup.dart';
import 'package:fluatter/src/stackFrame.dart';

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

  List<Func> closures = [];

  List<StackFrame> stackFrames = [];

  void addClosure(Func func) {
    closures.add(func);
  }

  //https://the-ravi-programming-language.readthedocs.io/en/latest/lua_bytecode_reference.html
  //http://luaforge.net/docman/83/98/ANoFrillsIntroToLua51VMInstructions.pdf
  Interpreter() {
    _opcodes["SETTABUP"] = setabbup;
    _opcodes["CLOSURE"] = closure;
    _opcodes["LOADK"] = loadk;
    _opcodes["RETURN"] = $return;
  }

  void exec({bool saveLastFrame = false}) {
    while (stackFrames.isNotEmpty) {
      stackFrames.last.func.instructionStream
          .forEach((x) => _opcodes[x.name].exec(x.registerConstants, this));

      if (stackFrames.length == 1 && saveLastFrame) {
        return;
      }

      stackFrames.removeLast();
    }
  }

  Func findFuncByName(String funcName) {
    return funcName != "main"
        ? closures.firstWhere((x) => x.name == funcName)
        : mainFunc;
  }

  void call(String funcName, {bool saveLastFrame = false}) {
    stackFrames.add(StackFrame(func: findFuncByName(funcName)));
    exec(saveLastFrame: saveLastFrame);
  }
}
