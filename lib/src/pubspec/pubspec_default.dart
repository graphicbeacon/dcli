import 'package:pub_semver/pub_semver.dart';

import '../script/dependency.dart';
import '../script/script.dart';

import 'pubspec.dart';

///
/// If no user defined pubspec exists we need to create
/// a default pubspec with the standard set
/// of dependencies we inject.
class PubSpecDefault implements PubSpec // with DependenciesMixin
{
  PubSpecImpl _pubspec;
  final Script _script;

  @override
  String get name => _script.basename;
  @override
  Version get version => Version.parse('1.0.0');
  @override
  set version(Version version) => _pubspec.version = version;

  /// creates a pubspec for the given [_script].
  PubSpecDefault(this._script) {
    _pubspec = PubSpecImpl.fromString(_default());
  }

  /// Creates default content for a virtual pubspec
  String _default() {
    return '''
name: ${_script.basename}
version: $version
''';
  }

  @override
  set dependencies(List<Dependency> newDependencies) {
    _pubspec.dependencies = newDependencies;
  }

  @override
  List<Dependency> get dependencies => _pubspec.dependencies;

  @override
  List<Dependency> get dependencyOverrides => _pubspec.dependencyOverrides;

  // removed unti pupspec 0.14 is released
  // @override
  // List<Executable> get executables => _pubspec.executables;

  @override
  void saveToFile(String path) {
    _pubspec.saveToFile(path);
  }
}
