import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/day_month_time_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Displays a proposal in pending state on a card.
class PendingProposalCard extends StatefulWidget {
  final PendingProposal proposal;
  final bool showStatus;
  final bool showLastUpdate;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const PendingProposalCard({
    super.key,
    required this.proposal,
    this.showStatus = true,
    this.showLastUpdate = true,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<PendingProposalCard> createState() => _PendingProposalCardState();
}

class _PendingProposalCardState extends State<PendingProposalCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _changeHoverState(value: true),
      onExit: (_) => _changeHoverState(value: false),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 326),
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv1White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHovered
                ? _hoverBorderColor(context)
                : context.colors.elevationsOnSurfaceNeutralLv1White,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Topbar(
                    showStatus: widget.showStatus,
                    isFavorite: widget.isFavorite,
                    onFavoriteChanged: widget.onFavoriteChanged,
                  ),
                  _Category(
                    category: widget.proposal.category,
                  ),
                  const SizedBox(height: 4),
                  _Title(text: widget.proposal.title),
                  _Author(author: widget.proposal.author),
                  _FundsAndDuration(
                    funds: widget.proposal.fundsRequested,
                    duration: widget.proposal.duration,
                  ),
                  const SizedBox(height: 12),
                  _Description(text: widget.proposal.description),
                  const SizedBox(height: 24),
                  _ProposalInfo(
                    proposalStage: widget.proposal.publishStage,
                    version: widget.proposal.version,
                    lastUpdate: widget.proposal.lastUpdateDate,
                    commentsCount: widget.proposal.commentsCount,
                    showLastUpdate: widget.showLastUpdate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeHoverState({required bool value}) {
    setState(() {
      isHovered = value;
    });
  }

  Color _hoverBorderColor(BuildContext context) {
    return switch (widget.proposal.publishStage) {
      ProposalPublish.draft => context.colorScheme.secondary,
      ProposalPublish.published => context.colorScheme.primary,
    };
  }
}

class _Topbar extends StatelessWidget {
  final bool showStatus;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const _Topbar({
    required this.showStatus,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(),
        VoicesIconButton.filled(
          onTap: () {},
          style: _buttonStyle(context),
          child: VoicesAssets.icons.share.buildIcon(
            color: context.colorScheme.primary,
          ),
        ),
        if (onFavoriteChanged != null) ...[
          const SizedBox(width: 4),
          VoicesIconButton.filled(
            onTap: () => onFavoriteChanged?.call(!isFavorite),
            style: _buttonStyle(context),
            child: CatalystSvgIcon.asset(
              isFavorite
                  ? VoicesAssets.icons.starFilled.path
                  : VoicesAssets.icons.starOutlined.path,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return IconButton.styleFrom(
      padding: const EdgeInsets.all(10),
      backgroundColor: context.colors.onSurfacePrimary08,
      foregroundColor: context.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      iconSize: 18,
    );
  }
}

class _Category extends StatelessWidget {
  final String category;

  const _Category({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      category,
      style: context.textTheme.labelMedium?.copyWith(
        color: context.colors.textDisabled,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Author extends StatelessWidget {
  final String author;

  const _Author({
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VoicesAvatar(
            icon: Text(author[0]),
            backgroundColor: context.colors.primaryContainer,
            foregroundColor: context.colors.textOnPrimaryWhite,
          ),
          const SizedBox(width: 8),
          Text(
            author,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FundsAndDuration extends StatelessWidget {
  final String funds;
  final int duration;

  const _FundsAndDuration({
    required this.funds,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PropertyValue(
            title: context.l10n.fundsRequested,
            formattedValue: funds,
          ),
          _PropertyValue(
            title: context.l10n.duration,
            formattedValue: context.l10n.valueMonths(duration),
          ),
        ],
      ),
    );
  }
}

class _PropertyValue extends StatelessWidget {
  final String title;
  final String formattedValue;
  const _PropertyValue({
    required this.title,
    required this.formattedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        Text(
          formattedValue,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  const _Description({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colors.textOnPrimaryLevel0,
          ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ProposalInfo extends StatelessWidget {
  final ProposalPublish proposalStage;
  final int version;
  final DateTime lastUpdate;
  final int commentsCount;
  final bool showLastUpdate;

  const _ProposalInfo({
    required this.proposalStage,
    required this.version,
    required this.lastUpdate,
    required this.commentsCount,
    required this.showLastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesChip.rectangular(
          backgroundColor: proposalStage.isDraft
              ? context.colorScheme.secondary
              : context.colorScheme.primary,
          content: Text(
            _localizedProposalStage(
              proposalStage,
              context.l10n,
            ),
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.onWarning,
            ),
          ),
        ),
        const SizedBox(width: 4),
        VoicesChip.rectangular(
          leading: VoicesAssets.icons.documentText.buildIcon(
            color: context.colors.textOnPrimaryLevel1,
          ),
          content: Text(
            version.toString(),
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
        ),
        if (showLastUpdate) ...[
          const SizedBox(width: 4),
          VoicesPlainTooltip(
            message: _tooltipMessage(context),
            child: DayMonthTimeText(
              dateTime: lastUpdate,
            ),
          ),
        ],
        const Spacer(),
        VoicesChip.rectangular(
          backgroundColor: context.colors.elevationsOnSurfaceNeutralLv1Grey,
          leading: VoicesAssets.icons.chatAlt2.buildIcon(),
          content: Text(
            version.toString(),
            style: context.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  String _localizedProposalStage(
    ProposalPublish proposalStage,
    VoicesLocalizations l10n,
  ) {
    return switch (proposalStage) {
      ProposalPublish.draft => l10n.draft,
      ProposalPublish.published => l10n.finalProposal,
    };
  }

  String _tooltipMessage(BuildContext context) {
    final dt = DateFormatter.formatDateTimeParts(lastUpdate, includeYear: true);

    return context.l10n.publishedOn(dt.date, dt.time);
  }
}
