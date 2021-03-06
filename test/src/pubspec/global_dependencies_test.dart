@Timeout(Duration(seconds: 600))
import 'package:dcli/dcli.dart' hide equals;
import 'package:dcli/src/pubspec/global_dependencies.dart';
import 'package:dcli/src/script/dependency.dart';
import 'package:dcli/src/script/script.dart';
import 'package:dcli/src/script/virtual_project.dart';
import 'package:test/test.dart';

import '../util/test_file_system.dart';

void main() {
  test('load', () {
    TestFileSystem().withinZone((fs) {
      var content = '''
dependencies:
  args: ^1.5.2
  collection: ^1.14.12
  file_utils: ^0.1.3
  path: ^1.6.4
  ''';

      var expected = [
        Dependency.fromHosted('args', '^1.5.2'),
        Dependency.fromHosted('collection', '^1.14.12'),
        Dependency.fromHosted('file_utils', '^0.1.3'),
        Dependency.fromHosted('path', '^1.6.4'),
      ];

      var gd = GlobalDependencies.fromString(content);
      expect(gd.dependencies, equals(expected));
    });
  });

  test('dependency_overrides', () {
    TestFileSystem().withinZone((fs) {
      var content = '''
dependencies:
  args: ^1.5.2
  collection: ^1.14.12
  file_utils: ^0.1.3
  path: ^1.6.4
  dcli:
    path: /home/dcli
dependency_overrides:
  args:
    path: /home/args
  ''';

      var expected = [
        Dependency.fromPath('args', join(rootPath, 'home', 'args')),
        Dependency.fromHosted('collection', '^1.14.12'),
        Dependency.fromHosted('file_utils', '^0.1.3'),
        Dependency.fromHosted('path', '^1.6.4'),
        Dependency.fromPath('dcli', join(rootPath, 'home', 'dcli')),
      ];

      var gd = GlobalDependencies.fromString(content);
      expect(gd.dependencies, equals(expected));
    });
  });

  test('local dcli', () {
    TestFileSystem().withinZone((fs) {
      var content = '''
dependencies:
  dcli: ^1.0.44 
  args: ^1.5.2
  path: ^1.6.4

dependency_overrides:
  dcli: 
    path: /home/dcli
  ''';

      var expected = [
        Dependency.fromPath('dcli', join(rootPath, 'home', 'dcli')),
        Dependency.fromHosted('args', '^1.5.2'),
        Dependency.fromHosted('path', '^1.6.4'),
      ];

      var gd = GlobalDependencies.fromString(content);
      expect(gd.dependencies, equals(expected));
    });
  });

  test('local dcli - with file writes', () {
    TestFileSystem().withinZone((fs) {
      var content = '''
dependencies:
  dcli: ^1.0.44 
  args: ^1.5.2
  path: ^1.6.4

dependency_overrides:
  dcli: 
    path: /home/dcli
  ''';

      var paths = TestFileSystem();

      var workingDir = paths.unitTestWorkingDir;

      // create a temp 'dependencies.yaml
      var depPath = join(workingDir, GlobalDependencies.filename);

      depPath.write(content);

      var gd = GlobalDependencies.fromFile(depPath);

      var expected = [
        Dependency.fromPath('dcli', join(rootPath, 'home', 'dcli')),
        Dependency.fromHosted('args', '^1.5.2'),
        Dependency.fromHosted('path', '^1.6.4'),
      ];

      expect(gd.dependencies, equals(expected));
    });
  });

  test('local dcli - write virtual pubsec.yaml', () {
    TestFileSystem().withinZone((fs) {
      var content = '''
dependencies:
  dcli: ^1.0.44 
  args: ^1.5.2
  path: ^1.6.4

dependency_overrides:
  dcli: 
    path: ~/git/dcli
  ''';

      var workingDir = fs.unitTestWorkingDir;

      // over-ride the default 'dependencies.yaml
      var depPath = join(Settings().pathToDCli, GlobalDependencies.filename);
      var backup = '$depPath.bak';
      if (exists(backup)) {
        delete(backup);
      }
      copy(depPath, backup);
      depPath.write(content);

      var gd = GlobalDependencies.fromFile(depPath);

      var expected = [
        Dependency.fromPath('dcli', join('~', 'git', 'dcli')),
        Dependency.fromHosted('args', '^1.5.2'),
        Dependency.fromHosted('path', '^1.6.4'),
      ];

      expect(gd.dependencies, equals(expected));

      var testScriptPath = join(workingDir, 'depends_test.dart');

      // create a script
      testScriptPath.write('''
    void main()
    {
      print('hellow world');
    }
    ''');

      // load it
      var script = Script.fromFile(testScriptPath);

      // create a virtual project for it.
      var project = VirtualProject.create(script);

      var pubspec = project.pubSpec();

      expect(
          pubspec.dependencies
            ..sort((lhs, rhs) => lhs.name.compareTo(rhs.name)),
          equals(gd.dependencies
            ..sort((lhs, rhs) => lhs.name.compareTo(rhs.name))));

      delete(depPath);
      copy(backup, depPath);
    });
  });
}
