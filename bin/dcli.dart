import 'dart:io';

import 'package:dcli/src/script/entry_point.dart';

void main(List<String> arguments) {
  DCli().run(arguments);
}

class DCli {
  void run(List<String> arguments) {
    var exitCode = EntryPoint().process(arguments);

    exit(exitCode);
  }
}
