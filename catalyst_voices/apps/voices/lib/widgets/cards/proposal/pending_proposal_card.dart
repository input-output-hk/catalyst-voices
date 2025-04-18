import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/cards/proposal/proposal_border.dart';
import 'package:catalyst_voices/widgets/modals/proposals/share_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/text/day_month_time_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays a proposal in pending state on a card.
class PendingProposalCard extends StatefulWidget {
  final PendingProposal proposal;
  final bool showStatus;
  final bool showLastUpdate;
  final bool isFavorite;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteChanged;

  const PendingProposalCard({
    super.key,
    required this.proposal,
    this.showStatus = true,
    this.showLastUpdate = true,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<PendingProposalCard> createState() => _PendingProposalCardState();
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
          Text(
            key: const Key('Author'),
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

class _Category extends StatelessWidget {
  final String category;

  const _Category({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      key: const Key('Category'),
      category,
      style: context.textTheme.labelMedium?.copyWith(
        color: context.colors.textDisabled,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  const _Description({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      key: const Key('Description'),
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colors.textOnPrimaryLevel0,
          ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            _PropertyValue(
              key: const Key('FundsRequested'),
              title: context.l10n.fundsRequested,
              formattedValue: funds,
            ),
            _PropertyValue(
              key: const Key('Duration'),
              title: context.l10n.duration,
              formattedValue: context.l10n.valueMonths(duration),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingProposalCardState extends State<PendingProposalCard> {
  late final WidgetStatesController _statesController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 454,
        maxHeight: 454,
        maxWidth: 326,
      ),
      child: Material(
        key: const Key('ProposalCard'),
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          statesController: _statesController,
          onTap: widget.onTap,
          canRequestFocus: true,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: ProposalBorder(
            publishStage: widget.proposal.publishStage,
            statesController: _statesController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Topbar(
                    proposalRef: widget.proposal.ref,
                    showStatus: widget.showStatus,
                    isFavorite: widget.isFavorite,
                    onFavoriteChanged: widget.onFavoriteChanged,
                  ),
                  _Category(
                    category: widget.proposal.category,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: _Title(text: widget.proposal.title),
                  ),
                  _Author(author: widget.proposal.author),
                  _FundsAndDuration(
                    funds: widget.proposal.fundsRequested,
                    duration: widget.proposal.duration,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _Description(text: widget.proposal.description),
                  ),
                  const SizedBox(height: 12),
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController();
  }
}

class _PropertyValue extends StatelessWidget {
  final String title;
  final String formattedValue;

  const _PropertyValue({
    required this.title,
    required this.formattedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          key: const Key('Title'),
          title,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        Text(
          key: const Key('Value'),
          formattedValue,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}

class _ProposalInfo extends StatelessWidget {
  final ProposalPublish proposalStage;
  final int version;
  final DateTime? lastUpdate;
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
        if (proposalStage.isDraft)
          const DraftProposalChip()
        else
          const FinalProposalChip(),
        const SizedBox(width: 4),
        ProposalVersionChip(version: version.toString()),
        if (showLastUpdate && lastUpdate != null) ...[
          const SizedBox(width: 4),
          VoicesPlainTooltip(
            message: _tooltipMessage(context),
            child: DayMonthTimeText(
              dateTime: lastUpdate!,
            ),
          ),
        ],
        const Spacer(),
        ProposalCommentsChip(
          commentsCount: commentsCount,
        ),
      ],
    );
  }

  String _tooltipMessage(BuildContext context) {
    if (lastUpdate == null) {
      return '';
    }
    final timezone = context.select<SessionCubit?, TimezonePreferences>(
      (value) => value?.state.settings.timezone ?? TimezonePreferences.local,
    );

    final effectiveData = switch (timezone) {
      TimezonePreferences.utc => lastUpdate!.toUtc(),
      TimezonePreferences.local => lastUpdate!.toLocal(),
    };
    final dt =
        DateFormatter.formatDateTimeParts(effectiveData, includeYear: true);

    return context.l10n.publishedOn(dt.date, dt.time);
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      key: const Key('Title'),
      text,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Topbar extends StatelessWidget {
  final DocumentRef proposalRef;
  final bool showStatus;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const _Topbar({
    required this.proposalRef,
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
        ShareButton(
          key: const Key('ShareBtn'),
          circle: false,
          onTap: () async {
            // TODO(LynxLynxx): Change to proposal view route when implemented
            final url = ProposalBuilderRoute(
              proposalId: proposalRef.id,
              proposalVersion: proposalRef.version,
            ).location;
            await ShareProposalDialog.show(context, url);
          },
        ),
        if (onFavoriteChanged != null) ...[
          const SizedBox(width: 4),
          FavoriteButton(
            key: const Key('FavoriteBtn'),
            circle: false,
            isFavorite: isFavorite,
            onChanged: onFavoriteChanged,
          ),
        ],
      ],
    );
  }
}
