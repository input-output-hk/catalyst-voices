import 'dart:io';

/// Reads all .csv files from <inputDirectory>, merges them, removes duplicate lines
/// and outputs a single CSV file at <outputFile>.
///
/// Usage: dart merge_svg_files.dart <packagePath> <outputFile>
/// - inputDirectory: The directory from where input CSV files are taken from.
/// - outputFile: Where to output the merged CSV file.
Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: <command> <inputDirectory> <outputFile>');
    exitCode = 1;
    return;
  }

  final inputDirectory = _getInputDirectory(args);
  final outputFile = _getOutputFile(args);
  final csvFiles = _listCsvFiles(inputDirectory, outputFile);
  final uniqueLines = _readUniqueLines(csvFiles);
  await _outputResult(outputFile, uniqueLines);
  await _deleteMergedFiles(csvFiles);
  print('✅ Output file license file at ${outputFile.path}');
}

Future<void> _deleteMergedFiles(Iterable<File> csvFiles) async {
  await csvFiles.map((e) => e.delete()).wait;
}

Directory _getInputDirectory(List<String> args) {
  final directory = Directory(args[0]);
  if (!directory.existsSync()) {
    throw ArgumentError('Error: Input directory does not exist.');
  }

  return directory;
}

File _getOutputFile(List<String> args) {
  return File(args[1]);
}

Iterable<File> _listCsvFiles(Directory directory, File outputFile) {
  return directory
      .listSync(recursive: false)
      .where((e) => e is File && e.path.toLowerCase().endsWith('.csv'))
      .where((e) => e.path != outputFile.path)
      .cast<File>();
}

Future<void> _outputResult(File outputFile, Set<String> uniqueLines) async {
  await outputFile.create(recursive: true);
  final outputSink = outputFile.openWrite();
  for (final line in uniqueLines) {
    if (line != uniqueLines.last) {
      outputSink.writeln(line);
    } else {
      outputSink.write(line);
    }
  }
  await outputSink.flush();
  await outputSink.close();
}

Set<String> _readUniqueLines(Iterable<File> csvFiles) {
  final result = <String>{};

  for (final file in csvFiles) {
    final lines = file.readAsLinesSync();
    for (final line in lines) {
      result.add(line);
    }
  }

  result.removeWhere((e) => e.trim().isEmpty);
  return result;
}
