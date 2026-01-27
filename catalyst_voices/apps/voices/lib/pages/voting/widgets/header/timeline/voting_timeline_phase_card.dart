part of 'voting_timeline_header.dart';

class _DateCounter extends StatelessWidget {
  final VotingTimelinePhaseViewModel phase;

  const _DateCounter({
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final dateRange = phase.dateRange;
    final startDate = dateRange.from;
    final endDate = dateRange.to;

    if (startDate == null || endDate == null) {
      return const _DateCounterText.placeholder();
    }

    final now = DateTimeExt.now();

    switch (phase.rangeStatus) {
      case DateRangeStatus.inRange:
        return const _DateCounterText.placeholder();
      case DateRangeStatus.before:
        var daysUntil = startDate.difference(now).inDays;
        daysUntil = daysUntil == 0 ? 1 : daysUntil;

        if (daysUntil.isNegative) {
          return const _DateCounterText.placeholder();
        }

        return _DateCounterText(
          label: context.l10n.votingTimelineStartingIn,
          value: context.l10n.votingTimelineStartingInXDays(daysUntil),
        );
      case DateRangeStatus.after:
        var daysSince = now.difference(endDate).inDays;
        daysSince = daysSince == 0 ? 1 : daysSince;

        if (daysSince.isNegative) {
          return const _DateCounterText.placeholder();
        }

        if (daysSince > 30) {
          return _DateCounterText(
            label: context.l10n.votingTimelineEnded,
            value: DateFormatter.formatFullDate24Format(endDate),
          );
        } else {
          return _DateCounterText(
            label: context.l10n.votingTimelineEnded,
            value: context.l10n.votingTimelineEndedXDaysAgo(daysSince),
          );
        }
    }
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
    final windowTitle = switch (phaseType) {
      VotingTimelinePhaseType.registration => context.l10n.votingTimelinePreVotingWindow,
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineVotingWindow,
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineTallyWindow,
      VotingTimelinePhaseType.results => context.l10n.votingTimelineResultsLabel,
    };

    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          windowTitle,
          style: textTheme.titleSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (dateRange == null || (startDate == null && endDate == null))
          Text(
            context.l10n.votingTimelineToBeAnnounced,
            style: textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          )
        else ...[
          if (startDate != null)
            _DateWindowRow(
              label: isResultsPhase
                  ? context.l10n.votingTimelineDrop
                  : context.l10n.votingTimelineStarts,
              date: startDate,
              isPhaseActive: isPhaseActive,
            ),
          if (endDate != null && !isResultsPhase) ...[
            _DateWindowRow(
              label: context.l10n.votingTimelineFinishes,
              date: endDate,
              isPhaseActive: isPhaseActive,
            ),
          ],
        ],
      ],
    );
  }
}

class _DateWindowRow extends StatelessWidget {
  final String label;
  final DateTime date;
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
    final formattedDate = DateFormatter.formatFullDate24Format(date);

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
          TextSpan(text: formattedDate),
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: _UtcBadge(),
            ),
          ),
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
  final VotingTimelinePhaseType phaseType;
  final bool isPhaseActive;

  const _Title({
    required this.phaseType,
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
            phaseType.getLabel(context),
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

class _UtcBadge extends StatelessWidget {
  const _UtcBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: colors.onSurfaceNeutralOpaqueLv2,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        context.l10n.utc,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.textOnPrimaryLevel1,
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1.45,
        ),
      ),
    );
  }
}

class _VotingTimelinePhaseCard extends StatelessWidget {
  final VotingTimelinePhaseViewModel phase;

  const _VotingTimelinePhaseCard({required this.phase});

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
          _DateCounter(phase: phase),
          const SizedBox(height: 1),
          _Title(
            phaseType: phase.type,
            isPhaseActive: isActive,
          ),
          SizedBox(height: isActive ? 12 : 4),
          Expanded(
            child: _Description(
              text: phase.description,
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
