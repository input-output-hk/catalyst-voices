part of 'voting_timeline_header.dart';

class _DateCounter extends StatelessWidget {
  final VotingTimelineDateCounterViewModel dateCounter;

  const _DateCounter({
    required this.dateCounter,
  });

  @override
  Widget build(BuildContext context) {
    final dateCounterType = dateCounter.type;
    if (dateCounterType == VotingTimelineDateCounterType.hidden) {
      return const _DateCounterText.placeholder();
    }

    final data = switch (dateCounterType) {
      VotingTimelineDateCounterType.startingIn => (
        label: context.l10n.votingTimelineStartingIn,
        value: context.l10n.votingTimelineStartingInXDays(dateCounter.daysCount),
      ),
      VotingTimelineDateCounterType.startingWithDate => (
        label: context.l10n.votingTimelineStarting,
        value: DateFormatter.formatFullDateFormat(dateCounter.date),
      ),
      VotingTimelineDateCounterType.endedDaysAgo => (
        label: context.l10n.votingTimelineEnded,
        value: context.l10n.votingTimelineEndedXDaysAgo(dateCounter.daysCount),
      ),
      VotingTimelineDateCounterType.endedWithDate => (
        label: context.l10n.votingTimelineEnded,
        value: DateFormatter.formatFullDateFormat(dateCounter.date),
      ),
      // handled above
      VotingTimelineDateCounterType.hidden => (label: '', value: ''),
    };

    return _DateCounterText(
      label: data.label,
      value: data.value,
    );
  }
}

class _DateCounterText extends StatelessWidget {
  final String label;
  final String value;
  final bool visible;

  const _DateCounterText({
    required this.label,
    required this.value,
  }) : visible = true;

  const _DateCounterText.placeholder() : label = '', value = '', visible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return Visibility.maintain(
      visible: visible,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text.rich(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: textStyle?.copyWith(
                  color: colors.textOnPrimaryLevel1,
                ),
              ),
              TextSpan(
                text: ' ',
                style: textStyle,
              ),
              TextSpan(
                text: value,
                style: textStyle?.copyWith(
                  color: colors.textOnPrimaryLevel0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateWindow extends StatelessWidget {
  final VotingTimelinePhaseType phaseType;
  final DateRange? dateRange;
  final bool isPhaseActive;

  const _DateWindow({
    required this.phaseType,
    required this.dateRange,
    required this.isPhaseActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final textColor = isPhaseActive
        ? theme.colors.textOnPrimaryWhite
        : theme.colors.textOnPrimaryLevel0;

    final startDate = dateRange?.from;
    final endDate = dateRange?.to;
    final isResultsPhase = phaseType == VotingTimelinePhaseType.results;
    final windowLabel = phaseType.getDateWindowLabel(context);

    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          windowLabel,
          style: textTheme.titleSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        _DateWindowRow(
          label: isResultsPhase
              ? context.l10n.votingTimelineDrop
              : context.l10n.votingTimelineStarts,
          date: startDate,
          isPhaseActive: isPhaseActive,
        ),
        if (!isResultsPhase)
          _DateWindowRow(
            label: context.l10n.votingTimelineFinishes,
            date: endDate,
            isPhaseActive: isPhaseActive,
          ),
      ],
    );
  }
}

class _DateWindowRow extends StatelessWidget {
  final String label;
  final DateTime? date;
  final bool isPhaseActive;

  const _DateWindowRow({
    required this.label,
    required this.date,
    required this.isPhaseActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final textColor = isPhaseActive ? colors.textOnPrimaryWhite : colors.textOnPrimaryLevel0;
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: textColor,
    );

    return Text.rich(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: textStyle?.copyWith(
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
          const TextSpan(text: ' '),
          if (date case final date?)
            WidgetSpan(
              child: TimezoneDateTimeText(
                date,
                formatter: (context, dateTime) => DateFormatter.formatFullDate24Format(dateTime),
                style: textStyle,
              ),
            )
          else
            TextSpan(text: context.l10n.votingTimelineToBeAnnounced),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;
  final bool isPhaseActive;

  const _Description({
    required this.text,
    required this.isPhaseActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Text(
      text,
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: isPhaseActive ? colors.textOnPrimaryWhite : colors.textOnPrimaryLevel0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.iconsBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.iconsPrimary,
            ),
          ),
          Text(
            context.l10n.votingTimelineLive,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.linksPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  final bool isVotingDelegated;
  final bool isPhaseActive;

  const _Title({
    required this.text,
    required this.isVotingDelegated,
    required this.isPhaseActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      spacing: 8,
      children: [
        if (isPhaseActive) const _LiveBadge(),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isPhaseActive
                  ? theme.colors.textOnPrimaryWhite
                  : theme.colors.textOnPrimaryLevel0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _VotingTimelinePhaseCard extends StatelessWidget {
  final VotingTimelinePhaseViewModel phase;
  final bool isVotingDelegated;

  const _VotingTimelinePhaseCard({
    required this.phase,
    required this.isVotingDelegated,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = phase.isActive;
    final decoration = (
      gradient: isActive ? LinearGradient(colors: context.colors.actionsGradientBackground) : null,
      image: isActive
          ? DecorationImage(
              alignment: Alignment.topLeft,
              image: VoicesAssets.images.actionPixelsBackground.provider(
                package: 'catalyst_voices_assets',
              ),
            )
          : null,
      color: isActive ? null : Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
    );
    final title = phase.type.getLabel(context, isVotingDelegated: isVotingDelegated);
    final description = phase.type.getDescription(context, isVotingDelegated: isVotingDelegated);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ).subtract(const EdgeInsets.only(bottom: 4)),
      decoration: BoxDecoration(
        gradient: decoration.gradient,
        image: decoration.image,
        color: decoration.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DateCounter(dateCounter: phase.dateCounter),
          const SizedBox(height: 1),
          _Title(
            text: title,
            isVotingDelegated: isVotingDelegated,
            isPhaseActive: isActive,
          ),
          SizedBox(height: isActive ? 12 : 4),
          Expanded(
            child: _Description(
              text: description,
              isPhaseActive: isActive,
            ),
          ),
          const SizedBox(height: 12),
          _DateWindow(
            phaseType: phase.type,
            dateRange: phase.dateRange,
            isPhaseActive: isActive,
          ),
        ],
      ),
    );
  }
}
