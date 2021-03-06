@Timeout(Duration(minutes: 5))
import 'dart:io';
import 'package:dcli/dcli.dart' hide equals;
import 'package:dcli/src/shell/cmd_shell.dart';
import 'package:test/test.dart';

void main() {
  test('Detect Shell', () {
    //TestFileSystem().withinZone((fs) {
    var shell = Shell.current;
    print(shell.name);

    String expected;
    if (Settings().isWindows) {
      expected = CmdShell.shellName;
    } else if (Platform.isLinux) {
      expected = BashShell.shellName;
    } else if (Platform.isMacOS) {
      expected = ZshShell.shellName;
    }

    expect(shell.name, equals(expected));
  });
//  }, skip: false);
}
