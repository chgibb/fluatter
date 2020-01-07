import 'dart:convert';

import 'package:fluatter/src/lua.dart';

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
  int upvalues;
  int locals;
  int constants;
  int functions;
  int params;
  List<Instruction> instructions = [];

  var flushFunction = () {
    interpreter.addFunction(Func(
        name: funcName,
        slots: slots,
        upvalues: upvalues,
        locals: locals,
        constants: constants,
        functions: functions,
        params: params,
        instructionStream: instructions));

    funcName = "";
    slots = 0;
    upvalues = 0;
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
        upvalues = int.parse(tokens[4]);
        locals = int.parse(tokens[6]);
        constants = int.parse(tokens[8]);
        functions = int.parse(tokens[10]);
        parseState = _ParseState.parsingFunctionBody;
        break;

      case _ParseState.parsingFunctionBody:
        List<String> tokens = lines[i].split(RegExp("\\s"));

        instructions.add(Instruction(
          name: tokens[3],
          A: int.tryParse(tokens[5]) ?? 0,
          B: int.tryParse(tokens[6]) ?? 0,
          C: int.tryParse(tokens[7]) ?? 0,
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
        break;
    }
  }

  return interpreter;
}
