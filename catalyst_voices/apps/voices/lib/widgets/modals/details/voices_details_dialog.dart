import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:flutter/material.dart';

class VoicesDetailsDialog extends StatelessWidget {
  final Widget header;
  final Widget body;

  const VoicesDetailsDialog({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      showClose: false,
      showBorder: true,
      constraints: const BoxConstraints(
        minWidth: 600,
        maxWidth: 900,
        minHeight: double.infinity,
      ),
      child: Column(
        children: [
          header,
          Expanded(child: body),
        ],
      ),
    );
  }
}
