import 'package:file_utils/file_utils.dart';

import 'package:path/path.dart' as p;

import '../settings.dart';
import 'dcli_function.dart';
import 'is.dart';

/// Updates the last modified time stamp of a file.
///
/// ```dart
/// touch('fred.txt');
/// touch('fred.txt, create: true');
/// ```
///
///
/// If [create] is true and the file doesn't exist
/// it will be created.
///
/// If [create] is false and the file doesn't exist
/// a [TouchException] will be thrown.
///
/// [create] is false by default.
///
/// As a convenience the touch function returns the [path] variable
/// that was passed in.
String touch(String path, {bool create = false}) =>
    _Touch().touch(path, create: create);

class _Touch extends DCliFunction {
  String touch(String path, {bool create = false}) {
    var absolutePath = p.absolute(path);

    Settings().verbose('touch: $absolute create: $create');

    if (!exists(p.dirname(absolutePath))) {
      throw TouchException(
          'The directory tree above $absolute does not exist. Create the tree and try again.');
    }
    if (create == false && !exists(absolutePath)) {
      throw TouchException(
          'The file $absolute does not exist. Did you mean to use touch(path, create: true) ?');
    }

    try {
      if (!FileUtils.touch([absolutePath], create: true)) {
        throw TouchException(
            'Unable to touch file $absolute: check permissions');
      }
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      throw TouchException('An error occured touching $absolute: $e');
    }
    return path;
  }
}

/// thrown when the [touch] function encounters an exception
class TouchException extends DCliFunctionException {
  /// thrown when the [touch] function encounters an exception
  TouchException(String reason) : super(reason);
}
