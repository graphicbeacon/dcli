import 'dart:io';

import 'package:dshell/dshell.dart';
import 'package:test/test.dart';

import 'test_fs_zone.dart';

void main() {
  test('MemoryFileSystem', () {
    TestZone().run(() {
      // final fs = MemoryFileSystem();

      // fs.directory('/tmp').createSync();
      // assert(fs.statSync('/tmp').type != FileSystemEntityType.notFound);

      // fs.file('.');

      print('root cwd: ${Directory.current}');

      print('testzone cwd: ${Directory.current}');

      Directory.current = '/';
      var dir = 'mfs.test';
      // Directory(dir).createSync();
      createDir(dir);
      cd(dir);
      print('testzone post cwd: ${pwd}');
    });
  }, skip: false);
}