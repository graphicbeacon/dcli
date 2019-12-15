import 'package:test/test.dart' as t;
import "package:dshell/dshell.dart";

import '../test_settings.dart';
import '../util.dart';
import '../util/test_fs_zone.dart';

String testFile;
void main() {
  Settings().debug_on = true;

  t.group("Cat", () {
    // Don't know how to test this as it writes directly to stdout.
    // Need some way to hook Stdout
    t.test("Cat good ", () {
      TestZone().run(() {
        print("PWD $pwd");
        testFile = join(TEST_ROOT, "lines.txt");
        createLineFile(testFile, 10);

        List<String> lines = List();
        cat(testFile, stdout: (line) => lines.add(line));
        t.expect(lines.length, t.equals(10));
      });
    });

    t.test("cat non-existing ", () {
      TestZone().run(() {
        t.expect(() => cat("bad file.text"),
            t.throwsA(t.TypeMatcher<CatException>()));
      });
    });
  });
}
