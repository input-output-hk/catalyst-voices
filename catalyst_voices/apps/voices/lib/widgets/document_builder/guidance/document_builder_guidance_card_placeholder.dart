import 'package:catalyst_voices/widgets/common/semantics/combine_semantics.dart';
import 'package:catalyst_voices/widgets/document_builder/guidance/document_builder_guidance_card.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A loading placeholder for the [DocumentBuilderGuidanceCard].
class DocumentBuilderGuidanceCardPlaceholder extends StatelessWidget {
  const DocumentBuilderGuidanceCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CombineSemantics(
      identifier: 'DocumentBuilderGuidancePlaceholder',
      container: true,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colors.onSurfacePrimary012,
        ),
      ),
    );
  }
}
