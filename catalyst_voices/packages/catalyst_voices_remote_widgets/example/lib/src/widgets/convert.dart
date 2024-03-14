import 'package:catalyst_voices_remote_widgets/catalyst_voices_remote_widgets.dart';

Future<void> main() async {
  await RemoteWidgetConverter.rfwTxtToRfw(
    inputFile: 'remote_widget.rfwtxt',
    outputFile: 'remote_widget.rfw',
  );
  await RemoteWidgetConverter.rfwTxtToRfw(
    inputFile: 'new_remote_widget.rfwtxt',
    outputFile: 'new_remote_widget.rfw',
  );
}
