import 'package:fluatter/src/func.dart';
import 'package:fluatter/src/opCode.dart';
import 'package:fluatter/src/opCodes/call.dart';
import 'package:fluatter/src/opCodes/closure.dart';
import 'package:fluatter/src/opCodes/eq.dart';
import 'package:fluatter/src/opCodes/gettabup.dart';
import 'package:fluatter/src/opCodes/jmp.dart';
import 'package:fluatter/src/opCodes/loadk.dart';
import 'package:fluatter/src/opCodes/loadnil.dart';
import 'package:fluatter/src/opCodes/mul.dart';
import 'package:fluatter/src/opCodes/return.dart';
import 'package:fluatter/src/opCodes/settabup.dart';
import 'package:fluatter/src/opCodes/sub.dart';
import 'package:fluatter/src/stackFrame.dart';

class Interpreter {
  Map<dynamic, dynamic> _globalSymbols = {};

  dynamic R(int i, StackFrame stackFrame) {
    return stackFrame.registers[i];
  }

  // ignore: non_constant_identifier_names
  dynamic Kst(int n, Func func) => func.constants[n];
  // ignore: non_constant_identifier_names
  dynamic Gbl(dynamic sym) => _globalSymbols[sym];
  // ignore: non_constant_identifier_names
  dynamic Upvalue(dynamic n, StackFrame stackFrame) => stackFrame.upvalues[n];
  // ignore: non_constant_identifier_names
  dynamic RK(int i, StackFrame stackFrame) =>
      i < 0 ? Kst(i.abs(), stackFrame.func) : R(i, stackFrame);

  Map<String, OpCode> _opcodes = {};

  Func mainFunc;

  List<Func> closures = [];

  List<StackFrame> stackFrames = [];

  bool saveLastStackFrame = false;

  Map<int, dynamic> get upvalues => stackFrames.last?.upvalues;

  void addClosure(Func func) {
    closures.add(func);
  }

  //https://the-ravi-programming-language.readthedocs.io/en/latest/lua_bytecode_reference.html
  //http://luaforge.net/docman/83/98/ANoFrillsIntroToLua51VMInstructions.pdf
  //http://www.lua.inf.puc-rio.br/publications/mascarenhas09optimized.pdf
  //https://surface.syr.edu/cgi/viewcontent.cgi?article=1012&context=lcsmith_other
  //https://github.com/gamesys/moonshine/blob/master/vm/src/operations.js
  //https://github.com/zxh0/lua.go/blob/master/api/lua_vm.go
  Interpreter() {
    _opcodes["SETTABUP"] = setabbup;
    _opcodes["GETTABUP"] = gettabup;
    _opcodes["CLOSURE"] = closure;
    _opcodes["LOADK"] = loadk;
    _opcodes["LOADNIL"] = loadnil;
    _opcodes["EQ"] = eq;
    _opcodes["JMP"] = jmp;
    _opcodes["SUB"] = sub;
    _opcodes["MUL"] = mul;
    _opcodes["CALL"] = $call;
    _opcodes["RETURN"] = $return;
  }

  List<dynamic> exec({bool saveLastFrame = true}) {
    while (stackFrames.isNotEmpty) {
      while (stackFrames.isNotEmpty &&
          stackFrames.last.pc !=
              stackFrames.last.func.instructionStream.length) {
        var inst = stackFrames.last.func.instructionStream[stackFrames.last.pc];

        saveLastStackFrame = saveLastFrame;
        print(
            "${stackFrames.last.func.name}: ${stackFrames.last.pc} ${inst.name}");
        _opcodes[inst.name].exec(inst.registerConstants, this);
        saveLastStackFrame = !saveLastStackFrame;
        if (stackFrames.isNotEmpty) {
          ++stackFrames.last.pc;
        }
      }

      if (stackFrames.length == 1) {
        if (stackFrames.last.func.instructionStream.last.name == "RETURN") {
          if (stackFrames
                  .last.func.instructionStream.last.registerConstants[1] ==
              1) {
            if (!saveLastFrame) {
              stackFrames.removeLast();
            }
            return null;
          }
        }
      }
      if (stackFrames.isNotEmpty) {
        stackFrames.removeLast();
      }
    }
    return null;
  }

  Func findFuncByName(String funcName) {
    return funcName != "main"
        ? closures.firstWhere((x) => x.name == funcName)
        : mainFunc;
  }

  List<dynamic> call(String funcName, {bool saveLastFrame = true}) {
    if (stackFrames.isNotEmpty) {
      stackFrames.removeLast();
    }
    stackFrames.add(StackFrame(func: findFuncByName(funcName)));
    return exec(saveLastFrame: saveLastFrame);
  }
}
