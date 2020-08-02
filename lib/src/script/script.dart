import 'dart:io';
import 'dart:math';

import 'package:dshell/src/settings.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';

import '../functions/is.dart';
import '../pubspec/pubspec_annotation.dart';
import '../util/dshell_paths.dart';

import '../util/file_helper.dart';

import 'command_line_runner.dart';

/// Used to manage a DShell script.
///
/// This class is primarily for internal use.
///
/// We expose [Script] as it permits some self discovery
/// of the script you are currently running.
///
///
class Script {
  /// The directory where the script file lives
  /// stored as an absolute path.
  final String _scriptDirectory;

  /// Name of the dart script
  final String _scriptname;

  /// Creates a script object from a scriptArg
  /// passed to a command.
  ///
  /// The [script] may be a filename or
  /// a filename with a path prefix (relative or absolute)
  /// If the path is realtive then it will be joined
  /// with the current working directory to form
  /// a absolute path.
  ///
  /// To obtain a [Script] instance for your cli application call:
  ///
  /// ```dart
  /// var script = Script.fromFile(Platform.script.toFilePath());
  ///
  Script.fromFile(
    String script,
  )   : _scriptname = _extractScriptname(script),
        _scriptDirectory = _extractScriptDirectory(script);

  /// the file name of the script including the extension.
  String get scriptname => _scriptname;

  /// the absolute path to the directory the script lives in
  String get scriptDirectory => _scriptDirectory;

  /// the absolute path of the script file.
  String get path => p.join(scriptDirectory, scriptname);

  /// the name of the script without its extension.
  /// this is used for the 'name' key in the pubspec.
  String get pubsecNameKey => p.basenameWithoutExtension(scriptname);

  /// The scriptname without its '.dart' extension.
  String get basename => p.basenameWithoutExtension(scriptname);

  /// the path to a scripts local pubspec.yaml.
  /// Only a script that has a pubspec.yaml in the same directory as the script
  /// will have a pubspec.yaml at this location.
  ///
  /// You should use [VirtualProject.projectPubspecPath] as that will always point
  /// the the correct pubspec.yaml regardless of the project type.
  String get localPubSpecPath => p.join(_scriptDirectory, 'pubspec.yaml');

  // the scriptnameArg may contain a relative path: fred/home.dart
  // we need to get the actually name and full path to the script file.
  static String _extractScriptname(String scriptArg) {
    var cwd = Directory.current.path;

    return p.basename(p.join(cwd, scriptArg));
  }

  static String _extractScriptDirectory(String scriptArg) {
    var cwd = Directory.current.path;

    var scriptDirectory = p.canonicalize(p.dirname(p.join(cwd, scriptArg)));

    return scriptDirectory;
  }

  /// Generates the default scriptfile contents
  /// when use runs 'dshell create <script>'
  ///
  void createDefaultFile(String defaultBody) {
    writeToFile(path, defaultBody);
  }

  /// When we create a dshell script using 'dshell create' we need
  /// a default body for the script.
  /// This methods returns a default body as a String.
  String generateDefaultBody() {
    /// The default body of the script we generate.
    return """#! /usr/bin/env ${DShellPaths().dshellName}

import 'dart:io';
import 'package:dshell/dshell.dart';

/// dshell script generated by:
/// dshell create $scriptname
/// 
/// See 
/// https://pub.dev/packages/dshell#-installing-tab-
/// 
/// For details on installing dshell.
/// 

void main() {
  print('Hello World');
}
""";
  }

  /// validate that the passed arguments points to
  static void validate(String scriptPath) {
    if (!scriptPath.endsWith('.dart')) {
      throw InvalidArguments(
          'Expected a script name (ending in .dart) instead found: $scriptPath');
    }

    if (!exists(scriptPath)) {
      throw InvalidScript(
          'The script ${p.absolute(scriptPath)} does not exist.');
    }
    if (!FileSystemEntity.isFileSync(scriptPath)) {
      throw InvalidScript(
          'The script ${p.absolute(scriptPath)} is not a file.');
    }
  }

  /// Returns true if the script has a pubspec.yaml in its directory.
  bool hasLocalPubSpecYaml() {
    // The virtual project pubspec.yaml file.
    final pubSpecPath = p.join(_scriptDirectory, 'pubspec.yaml');
    return exists(pubSpecPath);
  }

  bool _hasPubspecAnnotation;

  /// true if the script has a @pubspec annotation embedded.
  bool get hasPubspecAnnotation {
    if (_hasPubspecAnnotation == null) {
      var pubSpec = PubSpecAnnotation.fromScript(this);
      _hasPubspecAnnotation = pubSpec.annotationFound();
    }
    return _hasPubspecAnnotation;
  }

  /// Strips the root prefix of a path so we can use
  /// it as part of the virtual projects path.
  /// For linux this just removes any leading /
  /// For windows this removes c:\
  static String sansRoot(String path) {
    return path.substring(p.rootPrefix(path).length);
  }

  /// Determines the script project root.
  /// The project root is defined as the directory which contains
  /// the scripts 'pubspec.yaml' file.
  ///
  /// For a script which contains a @pubspec annotation or
  /// a script which doesn't have a pubspec.yaml
  /// this is the same directory that the script lives in.
  ///
  ///
  String get projectRoot {
    var current = _scriptDirectory;

    /// Script has a @pubspec annotation so the project root is the script directory
    if (hasPubspecAnnotation) {
      return _scriptDirectory;
    }

    var root = rootPrefix(path);

    // traverse up the directory to find if we are in a traditional directory.
    while (current != root) {
      if (exists(join(dirname(current), 'pubspec.yaml'))) {
        return dirname(current);
      }
      current = dirname(current);
    }

    /// no pubspec.yaml found so the project root is the script directory
    return _scriptDirectory;
  }

  static Script _current;

  /// Returns the instance of the currently running script.
  ///
  static Script get current {
    _current ??= Script.fromFile(Settings().scriptPath);
    return _current;
  }
}

// ignore: avoid_classes_with_only_static_members
///
class PithyGreetings {
  ///
  static List<String> greeting = [
    'Hello World',
    'Helwo vorld',
    'Build and Ben flower pot men. Weeeeeeeed.',
    "I'm a little tea pot.",
    'Are we there yet.',
    'Hurry up, says Mr Blackboard',
    "Damed if you do, Damed if you don't, so just get the hell on with it.",
    'Yep, this is all of it.',
    "I don't like your curtains"
  ];

  /// returns a random pithy greeting.
  static String random() {
    var selected = Random().nextInt(greeting.length - 1);

    return greeting[selected];
  }
}
