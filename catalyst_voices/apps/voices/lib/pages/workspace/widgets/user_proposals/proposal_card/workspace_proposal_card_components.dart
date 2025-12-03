part of 'workspace_proposal_card.dart';

class _BodyHeader extends StatelessWidget {
  final String title;
  final DateTime lastUpdate;
  final UserProposalOwnership ownership;

  const _BodyHeader({
    required this.title,
    required this.lastUpdate,
    required this.ownership,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = _ProposalSubmitState.of(context)?.headerColor(context);
    final labelColor = _ProposalSubmitState.of(context)?.headerLabelColor(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        _LeadingIcon(ownership: ownership),
        Column(
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
            Row(
              spacing: 8,
              children: [
                Text(
                  ownership.title(context),
                  style: context.textTheme.labelMedium?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                LastEditDate(
                  dateTime: lastUpdate,
                  showTimezone: false,
                  textStyle: context.textTheme.labelMedium?.copyWith(
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ],
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

class _LeadingIcon extends StatelessWidget {
  final UserProposalOwnership ownership;

  const _LeadingIcon({required this.ownership});

  @override
  Widget build(BuildContext context) {
    // TODO(LynxLynxx): Wrap with tooltip or gesture detector to show menu collaborators
    return Container(
      decoration: BoxDecoration(
        color: context.colors.onSurfaceNeutralOpaqueLv0,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(4),
      child: ownership.icon.buildIcon(
        size: 28,
        color: context.colors.iconsPrimary,
      ),
    );
  }
}
