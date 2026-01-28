import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/semantics/combine_semantics.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Shows a single guidance [item] on a card.
class DocumentBuilderGuidanceCard extends StatelessWidget {
  final DocumentBuilderGuidanceItem item;

  const DocumentBuilderGuidanceCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      identifier: 'DocumentBuilderGuidanceCard[${item.nodeId}]',
      container: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colors.elevationsOnSurfaceNeutralLv2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CombineSemantics(
              identifier: 'DocumentBuilderGuidanceCardSegment',
              container: true,
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: VoicesAssets.icons.newspaper.buildIcon(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.segmentTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (item.sectionTitle.isNotEmpty) ...[
              CombineSemantics(
                identifier: 'DocumentBuilderGuidanceCardSection',
                container: true,
                child: Text(
                  item.sectionTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colors.textOnPrimaryLevel1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            CombineSemantics(
              identifier: 'DocumentBuilderGuidanceCardDescription',
              container: true,
              child: MarkdownText(
                item.description,
                pStyle: context.textTheme.bodyMedium,
                pColor: theme.colors.textOnPrimaryLevel1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
