// ignore_for_file: avoid_print

import 'dart:async';

import 'package:remote_widgets/formats.dart';

Future<void> main() async {
  await RemoteWidgetEncoder.rfwTxtToRfw(
    inputFile: 'rfwtxt/remote_widget.rfwtxt',
    outputFile: 'rfw/remote_widget.rfw',
  );

  await RemoteWidgetEncoder.rfwTxtToRfw(
    inputFile: 'rfwtxt/new_remote_widget.rfwtxt',
    outputFile: 'rfw/new_remote_widget.rfw',
  );

  await RemoteWidgetEncoder.rfwTxtToRfw(
    inputFile: 'rfwtxt/test.rfwtxt',
    outputFile: 'rfw/test.rfw',
  );
}
