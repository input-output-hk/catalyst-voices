part of 'workspace_proposal_card.dart';

class _BodyHeader extends StatelessWidget {
  final String title;
  final DateTime lastUpdate;

  const _BodyHeader({
    required this.title,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = _ProposalSubmitState.of(context)?.headerColor(context);
    final labelColor = _ProposalSubmitState.of(context)?.headerLabelColor(context);
    return Column(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            color: headerColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        LastEditDate(
          dateTime: lastUpdate,
          showTimezone: false,
          textStyle: context.textTheme.labelMedium?.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _CampaignData extends StatelessWidget {
  final String leadValue;
  final String subValue;

  const _CampaignData({
    required this.leadValue,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = _ProposalSubmitState.of(context)?.dataLabelColor(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          leadValue,
          style: context.textTheme.titleSmall?.copyWith(
            color: labelColor,
          ),
        ),
        Text(
          subValue,
          style: context.textTheme.labelMedium?.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
