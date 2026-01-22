import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_card_placeholder.dart';
import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_list.dart';
import 'package:flutter/material.dart';

/// A loading placeholder for the [DocumentBuilderGuidanceList].
class DocumentBuilderGuidanceListPlaceholder extends StatelessWidget {
  const DocumentBuilderGuidanceListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        DocumentBuilderGuidanceCardPlaceholder(),
        DocumentBuilderGuidanceCardPlaceholder(),
      ],
    );
  }
}
