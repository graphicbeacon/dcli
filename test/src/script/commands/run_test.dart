@Timeout(Duration(seconds: 610))

import 'package:dcli/dcli.dart' hide equals;
import 'package:dcli/src/script/entry_point.dart';
import 'package:dcli/src/util/dcli_paths.dart';
import 'package:dcli/src/util/runnable_process.dart';
import 'package:test/test.dart';

import '../../util/test_file_system.dart';

void main() {
  test('Create and run a script', () {
    TestFileSystem().withinZone((fs) {
      var scriptPath = truepath(fs.testScriptPath, 'run_test');

      if (!exists(scriptPath)) {
        createDir(scriptPath, recursive: true);
      }
      var script = truepath(scriptPath, 'print_to_stdout.dart');

      // make certain our test script exists and is in a runnable state.
      '${DCliPaths().dcliName} -v create -fg $script'.run;

      EntryPoint().process(['run', script]);

      deleteDir(scriptPath, recursive: true);
    });
  });
  test('Run hello world', () {
    TestFileSystem().withinZone((fs) {
      var results = <String>[];

      '${DCliPaths().dcliName} -v test/test_scripts/general/bin/hello_world.dart'
          .forEach((line) => results.add(line), stderr: printerr);

      // if clean hasn't been run then we have the results of a pub get in the the output.

      expect(results, anyOf([contains(getExpected()), equals(getExpected())]));
    });
  });

  test('run with virtual pubspec', () {
    TestFileSystem().withinZone((fs) {
      var exit = -1;
      try {
        // with a virtual pubspec
        exit = EntryPoint()
            .process(['run', 'test/test_scripts/general/bin/which.dart', 'ls']);
      } on DCliException catch (e) {
        print(e);
      }
      expect(exit, equals(0));
    });
  });

  test('run  with a local pubspec', () {
    TestFileSystem().withinZone((fs) {
      var exit = -1;
      try {
        print(pwd);

        exit = EntryPoint().process(
            ['-v', 'run', 'test/test_scripts/local_pubspec/hello_world.dart']);
      } on DCliException catch (e) {
        print(e);
      }
      expect(exit, equals(0));
    });
  });

  test('run  with traditional dart project structure - bin', () {
    TestFileSystem().withinZone((fs) {
      var exit = -1;
      try {
        print(pwd);

        exit = EntryPoint().process([
          '-v',
          'run',
          'test/test_scripts/traditional_project/bin/traditional.dart'
        ]);
      } on DCliException catch (e) {
        print(e);
      }
      expect(exit, equals(0));
    });
  });

  test('run  with traditional dart project structure - nested bin', () {
    TestFileSystem().withinZone((fs) {
      var exit = -1;
      try {
        print(pwd);

        exit = EntryPoint().process([
          '-v',
          'run',
          'test/test_scripts/traditional_project/bin/nested/traditional.dart'
        ]);
      } on DCliException catch (e) {
        print(e);
      }
      expect(exit, equals(0));
    });
  });

  test('run  with traditional dart project structure - example', () {
    TestFileSystem().withinZone((fs) {
      var exit = -1;
      try {
        print(pwd);

        exit = EntryPoint().process([
          '-v',
          'run',
          'test/test_scripts/traditional_project/example/traditional.dart'
        ]);
      } on DCliException catch (e) {
        print(e);
      }
      expect(exit, equals(0));
    });
  }, skip: true);

  test('run  with traditional dart project structure - tool', () {
    TestFileSystem().withinZone((fs) {
      var exit = -1;
      try {
        print(pwd);

        exit = EntryPoint().process([
          '-v',
          'run',
          'test/test_scripts//traditional_project/tool/traditional.dart'
        ]);
      } on DCliException catch (e) {
        print(e);
      }
      expect(exit, equals(0));
    });
  });
}

String getExpected() {
  return 'Hello World';
}
