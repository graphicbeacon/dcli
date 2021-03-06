import 'package:pubspec/pubspec.dart';
import 'package:path/path.dart' as p;

import '../../dcli.dart';
import '../functions/touch.dart';
import '../script/dependency.dart';
import '../script/my_yaml.dart';

import 'dependencies_mixin.dart';

///
/// Global dependencies is a file located in ~/.dcli/dependencies.yaml
/// that contains a 'dependencies' section from a pubsec.yaml file.abstract
///
/// The global dependencies allows a user to inject a standard set
/// of dependencies into every script.
///
///
class GlobalDependencies with DependenciesMixin {
  /// name of the file we use to store the dcli global dependencies.
  static const filename = 'dependencies.yaml';
  MyYaml _yaml;

  /// ctor.
  GlobalDependencies() {
    if (!exists(pathTo)) {
      touch(pathTo, create: true);
    }
    _yaml = MyYaml.fromFile(pathTo);
  }

  /// Use this ctor for unit testing.
  GlobalDependencies.fromString(String yaml) {
    _yaml = MyYaml.fromString(yaml);
  }

  /// Use this ctor for unit testing.
  /// [dependenciesYamlPath] is the path to the 'dependencies.yaml'
  /// file you have created for unit testing.
  GlobalDependencies.fromFile(String dependenciesYamlPath) {
    _yaml = MyYaml.fromFile(dependenciesYamlPath);
  }

  /// path to the global dependencies file.
  static String get pathTo => p.join(Settings().pathToDCli, filename);

  @override
  MyYaml get yaml => _yaml;

  /// Creates the default global dependencies
  static void createDefault() {
    if (!exists(pathTo)) {
      pathTo.write('dependencies:');

      for (var dep in defaultDependencies) {
        pathTo.append(
            '  ${dep.name}: ${(dep.reference as HostedReference).versionConstraint.toString()}');
      }
    }
  }

  /// returns the list of default dependencies the
  /// global dependencies will be initialised with.
  static List<Dependency> get defaultDependencies {
    return [
      Dependency.fromHosted('dcli', '^0.20.0'),
      Dependency.fromHosted('args', '^1.5.2'),
      Dependency.fromHosted('path', '^1.6.4'),
    ];
  }
}
