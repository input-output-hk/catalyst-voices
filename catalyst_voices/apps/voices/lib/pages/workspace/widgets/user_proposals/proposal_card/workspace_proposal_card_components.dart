part of 'workspace_proposal_card.dart';

class _BodyHeader extends StatelessWidget {
  final String title;
  final DateTime lastUpdate;
  final UserProposalOwnership ownership;
  final List<Collaborator> collaborators;

  const _BodyHeader({
    required this.title,
    required this.lastUpdate,
    required this.ownership,
    required this.collaborators,
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
        _LeadingIcon(ownership: ownership, collaborators: collaborators),
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
  final List<Collaborator> collaborators;

  const _LeadingIcon({
    required this.ownership,
    required this.collaborators,
  });

  bool get _tooltipVisibility =>
      collaborators.isNotEmpty && ownership is CollaboratorProposalOwnership;

  @override
  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: _tooltipVisibility,
      child: Tooltip(
        richMessage: WidgetSpan(child: _TooltipOverlay(collaborators)),
        decoration: const BoxDecoration(),
        constraints: const BoxConstraints(maxWidth: 350),
        enableTapToDismiss: false,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.onSurfaceNeutralOpaqueLv0,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: ownership.icon.buildIcon(
            size: 28,
            color: context.colors.iconsPrimary,
          ),
        ),
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final List<Collaborator> collaborators;

  const _TooltipOverlay(this.collaborators);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.elevationsOnSurfaceNeutralLv1White,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: collaborators.map(_TooltipOverlayTile.new).toList(),
      ),
    );
  }
}

class _TooltipOverlayTile extends StatelessWidget {
  final Collaborator collaborator;

  const _TooltipOverlayTile(this.collaborator);

  @override
  Widget build(BuildContext context) {
    final idStyle = context.textTheme.labelSmall;
    final usernameStyle = (context.textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );
    final labelStatusStyle = (context.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ).add(const EdgeInsets.only(right: 8)),
      child: Row(
        spacing: 12,
        children: [
          collaborator.status
              .icon(context)
              .buildIcon(
                color: collaborator.status.statusColor(context),
                size: 24,
              ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AffixDecorator(
                suffix: CatalystIdText(
                  collaborator.catalystId,
                  isCompact: true,
                  showCopy: false,
                  copyEnabled: false,
                  tooltipEnabled: false,
                  style: idStyle,
                ),
                child: UsernameText(
                  collaborator.catalystId.username,
                  style: usernameStyle,
                  maxLines: 1,
                ),
              ),
              Text(
                collaborator.status.labelText(context),
                style: labelStatusStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
