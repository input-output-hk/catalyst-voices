import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesDetailsDialog extends StatelessWidget {
  final Widget header;
  final Widget body;
  final BoxConstraints constraints;
  final Color? backgroundColor;

  const VoicesDetailsDialog({
    super.key,
    required this.header,
    required this.body,
    this.constraints = const BoxConstraints(
      minWidth: 600,
      maxWidth: 900,
      minHeight: double.infinity,
    ),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      showClose: false,
      showBorder: true,
      constraints: constraints,
      backgroundColor: backgroundColor ??
          Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
      child: Column(
        children: [
          header,
          Expanded(child: body),
        ],
      ),
    );
  }
}
