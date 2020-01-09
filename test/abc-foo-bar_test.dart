import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Eval abc-foo-bar from listing', () {
/*
;Original file:
function foo()
    local a = 1
    local b = 2
    local c = 3
end

function bar()
    local a = 1
    local b = 2
    local c = 3
end
*/

    var interpreter = interpreterFromListing(
        File("fixtures/abc-foo-bar.txt").readAsStringSync());

    var mainFunc = interpreter.mainFunc;
    expect(mainFunc, isNotNull);
    expect(mainFunc.constants.length, 3);
    expect(mainFunc.constants[0], null);
    expect(mainFunc.constants[1], "foo");
    expect(mainFunc.constants[2], "bar");

    var foo = interpreter.findFuncByName("0x55566bee9990");
    expect(foo, isNotNull);
    expect(foo.constants.length, 4);
    expect(foo.constants[0], null);
    expect(foo.constants[1], 1);
    expect(foo.constants[2], 2);
    expect(foo.constants[3], 3);

    var bar = interpreter.findFuncByName("0x55566bee9fe0");
    expect(bar, isNotNull);
    expect(bar.constants.length, 4);
    expect(bar.constants[0], null);
    expect(bar.constants[1], 1);
    expect(bar.constants[2], 2);
    expect(bar.constants[3], 3);
    interpreter.call("main", saveLastFrame: true);

    expect(foo.name, "foo");
    expect(bar.name, "bar");
  });
}
