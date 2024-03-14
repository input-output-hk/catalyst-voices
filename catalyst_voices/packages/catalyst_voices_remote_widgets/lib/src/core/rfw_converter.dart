// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:rfw/formats.dart';

Future<void> main() async {
  await processFile('remote_widget.rfwtxt', 'remote_widget.rfw');
  await processFile('new_remote_widget.rfwtxt', 'new_remote_widget.rfw');
}

Future<void> processFile(
  String inputFilePath,
  String outputFilePath,
) async {
  try {
    print('Reading to $inputFilePath');
    final content = await File(inputFilePath).readAsString();
    print('Content: $content');

    final remoteWidgetLibrary = parseLibraryFile(content);
    final bytes = encodeLibraryBlob(remoteWidgetLibrary);

    await File(outputFilePath).writeAsBytes(bytes);
    print('Successfully processed $inputFilePath');
  } catch (e) {
    print('Failed to process $inputFilePath: $e');
  }
}
