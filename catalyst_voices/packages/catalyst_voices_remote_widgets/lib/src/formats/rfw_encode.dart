// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:rfw/formats.dart';

final class RemoteWidgetEncoder {
  const RemoteWidgetEncoder._();

  static Future<void> rfwTxtToRfw({
    required String inputFile,
    required String outputFile,
  }) async {
    try {
      print('Reading to $inputFile');
      final content = await File(inputFile).readAsString();
      print('Content: $content');

      final remoteWidgetLibrary = parseLibraryFile(content);
      final bytes = encodeLibraryBlob(remoteWidgetLibrary);

      await File(outputFile).writeAsBytes(bytes);
      print('Successfully processed $outputFile');
    } catch (e) {
      Exception('Failed to process $inputFile: $e');
    }
  }
}
