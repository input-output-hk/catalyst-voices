// ignore_for_file: avoid_print

import 'dart:async';

import 'package:catalyst_voices_remote_widgets/formats.dart';

Future<void> main() async {
  await RemoteWidgetEncoder.rfwTxtToRfw(
    inputFile: 'remote_widget.rfwtxt',
    outputFile: 'remote_widget.rfw',
  );

  await RemoteWidgetEncoder.rfwTxtToRfw(
    inputFile: 'new_remote_widget.rfwtxt',
    outputFile: 'new_remote_widget.rfw',
  );

  // await RemoteWidgetConverter.rfwTxtToRfw(
  //   inputFile: 'test.rfwtxt',
  //   outputFile: 'test.rfw',
  // );
}

// final class RemoteWidgetConverter {
//   const RemoteWidgetConverter._();

//   static Future<void> rfwTxtToRfw({
//     required String inputFile,
//     required String outputFile,
//   }) async {
//     try {
//       print('Reading to $inputFile');
//       final content = await File(inputFile).readAsString();

//       print('Content: $content');
//       final remoteWidgetLibrary = parseLibraryFile(content);

//       print('remoteWidgetLibrary: $remoteWidgetLibrary');

//       final bytes = encodeLibraryBlob(remoteWidgetLibrary);

//       await File(outputFile).writeAsBytes(bytes);
//       print('Successfully processed $inputFile');
//     } catch (e) {
//       Exception('Failed to process $inputFile: $e');
//     }
//   }
// }
