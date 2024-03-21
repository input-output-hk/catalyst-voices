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
}
