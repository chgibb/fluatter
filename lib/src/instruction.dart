import 'package:flutter/foundation.dart';

class Instruction {
  final String name;
  final List<int> registerConstants;

  Instruction({@required this.name, @required this.registerConstants});
}
