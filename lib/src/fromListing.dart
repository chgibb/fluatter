import 'dart:convert';

import 'package:fluatter/src/func.dart';
import 'package:fluatter/src/instruction.dart';
import 'package:fluatter/src/util/observableMap.dart';
import 'package:fluatter/src/vm.dart';
import 'package:fluatter/src/util/nextNonEmptyElement.dart';

enum _ParseState {
  nothing,
  parsingFunction,
  parsingFunctionHeader,
  parsingFunctionBody,
  parsingConstants,
  parsingLocals,
  parsingUpvalues
}

Interpreter interpreterFromListing(String listing) {
  Interpreter interpreter = Interpreter();
  List<String> lines = LineSplitter().convert(listing);

  _ParseState parseState = _ParseState.nothing;

  var maybeTransitionParseState = (List<String> lines, int i) {
    if (RegExp("(instructions at 0x)").hasMatch(lines[i])) {
      parseState = _ParseState.parsingFunction;
    }

    if (RegExp("(constants \\()").hasMatch(lines[i])) {
      parseState = _ParseState.parsingConstants;
    }
    if (RegExp("(locals \\()").hasMatch(lines[i])) {
      parseState = _ParseState.parsingLocals;
    }

    if (RegExp("(upvalues \\()").hasMatch(lines[i])) {
      parseState = _ParseState.parsingUpvalues;
    }
  };

  String funcName;
  int slots;
  int numupvalues;
  int numlocals;
  int numconstants;
  int functions;
  int params;
  List<Instruction> instructions = [];
  Map<int, dynamic> upvalues = {};
  Map<int, dynamic> constants = {};
  ObservableMap<int, dynamic> locals;

  var flushFunction = () {
    Func func = Func(
        name: funcName,
        slots: slots,
        numupvalues: numupvalues,
        numlocals: numlocals,
        numconstants: numconstants,
        functions: functions,
        params: params,
        instructionStream: instructions,
        upvalues: upvalues,
        constants: constants,
        locals: locals);
    if (func.name == "main") {
      interpreter.mainFunc = func;
    } else {
      interpreter.addClosure(func);
    }
    funcName = "";
    slots = 0;
    numupvalues = 0;
    numlocals = 0;
    numconstants = 0;
    functions = 0;
    params = 0;
    instructions = [];
    upvalues = {};
    constants = {};
    locals = ObservableMap("locals");
  };

  for (var i = 0; i != lines.length; ++i) {
    maybeTransitionParseState(lines, i);
    switch (parseState) {
      case _ParseState.nothing:
        break;

      case _ParseState.parsingFunction:
        if (instructions.isNotEmpty) {
          flushFunction();
        }
        List<String> tokens = lines[i].split(RegExp("\\s"));

        funcName = tokens[0] == "main" ? "main" : "";

        if (funcName == "") {
          funcName = RegExp("(0x(\d|\\w)+\\))").firstMatch(lines[i]).group(0);
          funcName = funcName.substring(0, funcName.length - 1);
        }

        parseState = _ParseState.parsingFunctionHeader;
        break;

      case _ParseState.parsingFunctionHeader:
        List<String> tokens = lines[i].split(RegExp("\\s"));
        slots = int.parse(tokens[2]);
        numupvalues = int.parse(tokens[4]);
        numlocals = int.parse(tokens[6]);
        numconstants = int.parse(tokens[8]);
        functions = int.parse(tokens[10]);
        parseState = _ParseState.parsingFunctionBody;
        break;

      case _ParseState.parsingFunctionBody:
        List<String> tokens = lines[i].split(RegExp("\\s"));
        var a = nextNonEmptyElement(tokens, 5);
        var b = nextNonEmptyElement(tokens, a.i + 1);
        var c = nextNonEmptyElement(tokens, b.i + 1);
        instructions.add(Instruction(
          name: tokens[3],
          registerConstants: [
            int.tryParse(a.element) ?? 0,
            int.tryParse(b.element) ?? 0,
            int.tryParse(c?.element ?? "") ?? 0
          ],
        ));
        break;

      case _ParseState.parsingConstants:
        List<String> tokens = lines[i].split(RegExp("\\s"));
        var index = nextNonEmptyElement(tokens, 0);

        var val = tokens.skip(index.i + 1).join("");

        if (val[0] == "\"") {
          val = val.substring(1, val.length);
          val = val.substring(0, val.length - 1);

          constants[int.tryParse(index.element)] = val;
          break;
        }

        constants[int.tryParse(index.element)] = int.tryParse(val);
        break;
      case _ParseState.parsingLocals:
        if (RegExp("(locals \\()").hasMatch(lines[i])) {
          break;
        }
        List<String> tokens = lines[i].split(RegExp("\\s"));
        var index = nextNonEmptyElement(tokens, 0);
        var val = nextNonEmptyElement(tokens, index.i + 1);
        locals[int.parse(index.element)] = val.element;
        break;

      case _ParseState.parsingUpvalues:
        List<String> tokens = lines[i].split(RegExp("\\s"));

        var key = nextNonEmptyElement(tokens, 0);
        upvalues[int.tryParse(key?.element ?? "") ?? 0] =
            Map<dynamic, dynamic>();
        break;
    }
  }

  if (instructions.isNotEmpty) {
    flushFunction();
  }

  return interpreter;
}
