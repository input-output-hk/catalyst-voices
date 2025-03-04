import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalDeliveryCard extends StatelessWidget {
  final int fundsRequested;
  final int projectDuration;
  final int milestoneCount;

  const ProposalDeliveryCard({
    super.key,
    required this.fundsRequested,
    required this.projectDuration,
    required this.milestoneCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.onSurfaceNeutralOpaqueLv1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 16,
        children: [
          _ValueCell(
            title: context.l10n.proposalViewFundingRequested,
            value: '',
            valueSuffix: const Currency.ada().format(
              fundsRequested,
              separator: ' ',
            ),
          ),
          _ValueCell(
            title: context.l10n.proposalViewProjectDuration,
            value: context.l10n
                .valueMonths(projectDuration)
                .replaceAll('$projectDuration', '')
                .trim(),
            valueSuffix: '$projectDuration',
          ),
          _ValueCell(
            title: context.l10n.proposalViewProjectDelivery,
            value: context.l10n
                .valueMilestones(milestoneCount)
                .replaceAll('$milestoneCount', '')
                .trim(),
            valueSuffix: '$milestoneCount',
          ),
        ].map<Widget>((e) => Expanded(child: e)).toList(),
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String title;
  final String value;
  final String valueSuffix;

  const _ValueCell({
    required this.title,
    required this.value,
    required this.valueSuffix,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    final valueSuffix = this.valueSuffix;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelMedium
              ?.copyWith(color: colors.textOnPrimaryLevel1),
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          spacing: 6,
          children: <Widget>[
            Text(
              valueSuffix,
              style: textTheme.headlineSmall
                  ?.copyWith(color: colors.textOnPrimaryLevel1),
            ),
            Text(
              value,
              style: textTheme.headlineSmall
                  ?.copyWith(color: colors.textOnPrimaryLevel1),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ],
    );
  }
}
