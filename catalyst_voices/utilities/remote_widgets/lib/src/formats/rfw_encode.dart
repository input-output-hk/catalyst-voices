// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:rfw/formats.dart';

/// A class that provides methods for encoding Remote Widget files.
final class RemoteWidgetEncoder {
  const RemoteWidgetEncoder._();

  /// Converts a text file in the Remote Widget format to the RFW binary format.
  ///
  /// The [inputFile] parameter specifies the path to the input text file.
  /// The [outputFile] parameter specifies the path to the output binary file.
  ///
  /// Throws an exception if the conversion fails.
  static Future<void> rfwTxtToRfw({
    required String inputFile,
    required String outputFile,
  }) async {
    try {
      print('Reading from $inputFile');
      final content = await File(inputFile).readAsString();
      print('Content: $content');

      final remoteWidgetLibrary = parseLibraryFile(content);
      final bytes = encodeLibraryBlob(remoteWidgetLibrary);

      await File(outputFile).writeAsBytes(bytes);
      print('Successfully processed $outputFile');
    } catch (e) {
      throw Exception('Failed to process $inputFile: $e');
    }
  }
}
