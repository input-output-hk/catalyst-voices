import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// An empty state widget to display that no guidance was selected.
class DocumentBuilderGuidanceNotSelected extends StatelessWidget {
  const DocumentBuilderGuidanceNotSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.selectASection);
  }
}
