import 'dart:convert';

import 'package:fluatter/src/lua.dart';
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
  int locals;
  int constants;
  int functions;
  int params;
  List<Instruction> instructions = [];
  Map<int, dynamic> upvalues = {};

  var flushFunction = () {
    interpreter.addFunction(Func(
        name: funcName,
        slots: slots,
        numupvalues: numupvalues,
        locals: locals,
        constants: constants,
        functions: functions,
        params: params,
        instructionStream: instructions,
        upvalues: upvalues));

    funcName = "";
    slots = 0;
    numupvalues = 0;
    locals = 0;
    constants = 0;
    functions = 0;
    params = 0;
    instructions = [];
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

        funcName = tokens[0];
        parseState = _ParseState.parsingFunctionHeader;
        break;

      case _ParseState.parsingFunctionHeader:
        List<String> tokens = lines[i].split(RegExp("\\s"));
        slots = int.parse(tokens[2]);
        numupvalues = int.parse(tokens[4]);
        locals = int.parse(tokens[6]);
        constants = int.parse(tokens[8]);
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
          A: int.tryParse(a.element) ?? 0,
          B: int.tryParse(b.element) ?? 0,
          C: int.tryParse(c?.element ?? "") ?? 0,
        ));
        break;

      case _ParseState.parsingConstants:
        if (instructions.isNotEmpty) {
          flushFunction();
        }
        break;

      case _ParseState.parsingLocals:
        if (instructions.isNotEmpty) {
          flushFunction();
        }
        break;

      case _ParseState.parsingUpvalues:
        if (instructions.isNotEmpty) {
          flushFunction();
        }
        List<String> tokens = lines[i].split(RegExp("\\s"));

        var key = nextNonEmptyElement(tokens, 0);
        break;
    }
  }

  return interpreter;
}
