import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// An empty state widget to showcase that given element
/// (section, property, etc). does not have any guidance.
class DocumentBuilderNoGuidance extends StatelessWidget {
  const DocumentBuilderNoGuidance({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.noGuidanceForThisSection);
  }
}
