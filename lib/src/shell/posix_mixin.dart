import 'dart:io';

import '../../dshell.dart';
import '../installers/apt_installer.dart';
import '../installers/macosx_installer.dart';

/// Provides a number of helper functions
/// when for posix based shells.
mixin PosixMixin {
  String get startScriptName;

  String get startScriptPath {
    return join(HOME, startScriptName);
  }

  /// Adds the given path to the zsh path if it isn't
  /// already on teh path.
  bool addToPath(String path) {
    if (!isOnPath(path)) {
      var export = 'export PATH=\$PATH:$path';

      var rcPath = startScriptPath;

      if (!exists(rcPath)) {
        rcPath.write(export);
      } else {
        rcPath.append(export);
      }
    }
    return true;
  }

  bool get isCompletionInstalled {
    var completeInstalled = false;
    var startFile = startScriptPath;

    if (startFile != null) {
      if (exists(startFile)) {
        read(startFile).forEach((line) {
          if (line.contains('dshell_complete')) {
            completeInstalled = true;
          }
        });
      }
    }
    return completeInstalled;
  }

  bool get isPrivilegedUser {
    var user = 'whoami'.firstLine;
    Settings().verbose('user: $user');
    var privileged = (user == 'root');
    Settings().verbose('isPrivilegedUser: $privileged');
    return privileged;
  }

  String get loggedInUser {
    String user;

    var line = 'who'.firstLine;
    Settings().verbose('who: $line');
    if (line != null) {
      // username :1
      var parts = line.split(':');
      if (parts.isNotEmpty) {
        user = parts[0];
      }
    }
    Settings().verbose('loggedInUser: $user');
    return user;
  }

  String privilegesRequiredMessage(String app) {
    return 'Please run with: sudo $app';
  }

  bool install() {
    if (Platform.isLinux) {
      return AptDShellInstaller().install();
    } else {
      return MacOsxDshellInstaller().install();
    }
  }
}