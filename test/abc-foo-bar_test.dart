import 'dart:io';

import 'package:fluatter/src/fromListing.dart';
import 'package:fluatter/src/lua.dart';
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
  });
}
