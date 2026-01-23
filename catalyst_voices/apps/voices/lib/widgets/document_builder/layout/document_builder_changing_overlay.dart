import 'package:catalyst_voices/widgets/indicators/voices_loading_overlay.dart';
import 'package:flutter/material.dart';

/// A full-screen widget intended to overlay the document builder
/// when the data is changing (saving, updating, deleting, etc).
class DocumentBuilderChangingOverlay extends StatelessWidget {
  final bool show;

  const DocumentBuilderChangingOverlay({
    super.key,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesLoadingOverlay(show: show);
  }
}
