import 'package:catalyst_voices/widgets/modals/details/voices_details_dialog_header.dart';
import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:flutter/material.dart';

class VoicesDetailsDialog extends StatelessWidget {
  final String title;
  final String titleLabel;
  final Widget body;

  const VoicesDetailsDialog({
    super.key,
    required this.title,
    required this.titleLabel,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      showClose: false,
      child: Column(
        children: [
          VoicesDetailsDialogHeader(
            title: title,
            titleLabel: titleLabel,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
