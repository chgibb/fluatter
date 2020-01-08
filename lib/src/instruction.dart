import 'package:flutter/foundation.dart';

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