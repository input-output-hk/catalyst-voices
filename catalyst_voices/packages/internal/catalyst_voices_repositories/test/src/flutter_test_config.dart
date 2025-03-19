import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // ignore: avoid_single_cascade_in_expression_statements
  open
    // TODO(damian-molinski): uncomment linux when we'll have working
    //  compilation
    // ..overrideFor(OperatingSystem.linux, _openOnLinux)
    ..overrideFor(OperatingSystem.macOS, _openOnMacOS);

  await testMain();
}

/*DynamicLibrary _openOnLinux() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final path = '${scriptDir.path}/test/sqlite/linux/libsqlite3.so';
  final libraryNextToScript = File(path);
  return DynamicLibrary.open(libraryNextToScript.path);
}*/

DynamicLibrary _openOnMacOS() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final path = '${scriptDir.path}/test/sqlite/macOS/libsqlite3.3.49.1.dylib';
  final libraryNextToScript = File(path);
  return DynamicLibrary.open(libraryNextToScript.path);
}
