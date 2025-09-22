import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalDeliveryCard extends StatelessWidget {
  final Money? fundsRequested;
  final int? projectDuration;
  final int? milestoneCount;

  const ProposalDeliveryCard({
    super.key,
    required this.fundsRequested,
    required this.projectDuration,
    required this.milestoneCount,
  });

  @override
  Widget build(BuildContext context) {
    final fundsRequested = this.fundsRequested;
    final projectDuration = this.projectDuration;
    final milestoneCount = this.milestoneCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.onSurfaceNeutralOpaqueLv1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.spaceAround,
        runAlignment: WrapAlignment.center,
        children: [
          if (fundsRequested != null)
            _ValueCell(
              title: context.l10n.proposalViewFundingRequested,
              value: '',
              valueSuffix: MoneyFormatter.formatDecimal(
                fundsRequested,
              ),
            ),
          if (projectDuration != null)
            _ValueCell(
              title: context.l10n.proposalViewProjectDuration,
              value: context.l10n
                  .valueMonths(projectDuration)
                  .replaceAll('$projectDuration', '')
                  .trim(),
              valueSuffix: '$projectDuration',
            ),
          if (milestoneCount != null)
            _ValueCell(
              title: context.l10n.proposalViewProjectDelivery,
              value: context.l10n
                  .valueMilestones(milestoneCount)
                  .replaceAll('$milestoneCount', '')
                  .trim(),
              valueSuffix: '$milestoneCount',
            ),
        ],
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
          style: textTheme.labelMedium?.copyWith(color: colors.textOnPrimaryLevel1),
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
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: textTheme.headlineSmall?.copyWith(color: colors.textOnPrimaryLevel1),
            ),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(color: colors.textOnPrimaryLevel1),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ],
    );
  }
}
