import 'package:dshell/script/project_cache.dart';

import '../command_line_runner.dart';
import '../flags.dart';
import '../project.dart';
import '../script.dart';
import 'commands.dart';

class CleanCommand extends Command {
  static const String NAME = "clean";

  CleanCommand() : super(NAME);

  /// [arguments] must contain a single script.
  @override
  int run(List<Flag> selectedFlags, List<String> arguments) {
    if (arguments.length != 1) {
      throw InvalidArguments(
          "The 'clean' command expects only a single script as its sole argument. Found ${arguments.join(",")} arguments.");
    }

    Script.validate(arguments);

    Script script = Script.fromArg(arguments[0]);

    VirtualProject project = VirtualProject(ProjectCache().path, script);

    project.clean();

    return 0;
  }

  String usage() => "clean <script path.dart>";

  String description() =>
      "Deletes the project cache for <scriptname.dart> and forces a rebuild of the script's cache.";
}