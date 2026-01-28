import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

/// Shows a list of guidance [items].
class DocumentBuilderGuidanceList extends StatelessWidget {
  final List<DocumentBuilderGuidanceItem> items;

  const DocumentBuilderGuidanceList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: items.map((e) => DocumentBuilderGuidanceCard(item: e)).toList(),
    );
  }
}
