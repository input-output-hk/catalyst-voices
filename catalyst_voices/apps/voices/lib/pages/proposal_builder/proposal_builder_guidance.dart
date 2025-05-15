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
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        ({bool isLoading, ProposalGuidance guidance})>(
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
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final ProposalGuidanceItem item;

  const _GuidanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colors.onSurfacePrimary012,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VoicesAssets.icons.newspaper.buildIcon(),
              const SizedBox(width: 4),
              Text(
                item.segmentTitle,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.sectionTitle,
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colors.textOnPrimaryLevel1),
          ),
          const SizedBox(height: 10),
          MarkdownText(item.description),
        ],
      ),
    );
  }
}

class _GuidanceCardPlaceholder extends StatelessWidget {
  const _GuidanceCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colors.onSurfacePrimary012,
      ),
    );
  }
}

class _GuidanceList extends StatelessWidget {
  final List<ProposalGuidanceItem> items;

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
