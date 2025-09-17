import 'dart:io';

import 'package:dart_pubspec_licenses/dart_pubspec_licenses.dart' as oss;
import 'package:path/path.dart' as path;

/// Generates a CSV license file with all dependencies (direct and transitive) from a <packagePath>.
///
/// Usage: dart generate_licenses.dart <packagePath> <outputFile>
/// - packagePath: The package path (where the pubspec.lock is) to analyze.
/// - outputFile: Where to output the CSV file.
Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: <command> <packagePath> <outputFile>');
    exitCode = 1;
    return;
  }

  final packageRoot = _parsePackageRoot(args);
  final outputFile = _parseOutputFile(args);
  final pubspecYamlPath = _getPubspecYamlPath(packageRoot);

  await outputFile.create(recursive: true);
  final outputSink = await outputFile.openWrite();
  outputSink.write(
    'Package Name${_sep}Description${_sep}Authors${_sep}License',
  );

  final deps = await oss.listDependencies(pubspecYamlPath: pubspecYamlPath);
  for (var entry in deps.allDependencies) {
    final name = _replaceSpecialCharacters(entry.name);
    final license = _replaceSpecialCharacters(entry.license ?? '');
    final description = _replaceSpecialCharacters(entry.description);
    final authors = _replaceSpecialCharacters(entry.authors.join(' | '));
    outputSink.writeln(
      '\n${name}${_sep}${description}${_sep}${authors}${_sep}${license}',
    );
  }

  await outputSink.flush();
  await outputSink.close();
}

String _sep = ',';

String _getPubspecYamlPath(String packageRoot) {
  final pubspecYamlPath = path.join(packageRoot, 'pubspec.yaml');
  if (!File(pubspecYamlPath).existsSync()) {
    throw ArgumentError('$pubspecYamlPath not found');
  }

  return pubspecYamlPath;
}

File _parseOutputFile(List<String> args) {
  return File(args[1]);
}

String _parsePackageRoot(List<String> args) {
  return args[0];
}

String _replaceSpecialCharacters(String string) {
  return string.replaceAll('\n', '').replaceAll(_sep, '');
}
