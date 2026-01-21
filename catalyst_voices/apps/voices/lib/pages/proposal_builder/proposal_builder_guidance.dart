import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/semantics/combine_semantics.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalBuilderGuidanceSelector extends StatelessWidget {
  const ProposalBuilderGuidanceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: 'ProposalBuilderGuidance',
      container: true,
      child:
          BlocSelector<
            ProposalBuilderBloc,
            ProposalBuilderState,
            ({bool isLoading, DocumentBuilderGuidance guidance})
          >(
            selector: (state) => (isLoading: state.isLoading, guidance: state.guidance),
            builder: (context, state) {
              if (state.isLoading) {
                return const _GuidanceListPlaceholder();
              } else if (state.guidance.isNoneSelected) {
                return Text(context.l10n.selectASection);
              } else if (state.guidance.showEmptyState) {
                return Text(context.l10n.noGuidanceForThisSection);
              } else {
                return _GuidanceList(items: state.guidance.guidanceList);
              }
            },
          ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final DocumentBuilderGuidanceItem item;

  const _GuidanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      identifier: 'ProposalBuilderGuidanceCard[${item.nodeId}]',
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
              identifier: 'ProposalBuilderGuidanceCardSegment',
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
                identifier: 'ProposalBuilderGuidanceCardSection',
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
              identifier: 'ProposalBuilderGuidanceCardDescription',
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

class _GuidanceCardPlaceholder extends StatelessWidget {
  const _GuidanceCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CombineSemantics(
      identifier: 'ProposalBuilderGuidancePlaceholder',
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

class _GuidanceList extends StatelessWidget {
  final List<DocumentBuilderGuidanceItem> items;

  const _GuidanceList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: items.map((e) => _GuidanceCard(item: e)).toList(),
    );
  }
}

class _GuidanceListPlaceholder extends StatelessWidget {
  const _GuidanceListPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        _GuidanceCardPlaceholder(),
        _GuidanceCardPlaceholder(),
      ],
    );
  }
}
