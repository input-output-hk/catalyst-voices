import 'package:catalyst_voices/common/ext/build_context_ext.dart';
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

/// Displays a proposal brief on a card.
class ProposalBriefCard extends StatefulWidget {
  final ProposalBrief proposal;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteChanged;
  final ValueChanged<VoteButtonAction>? onVoteAction;

  // TODO(LynxxLynx): This should come from campaign settings
  final bool readOnly;

  const ProposalBriefCard({
    super.key,
    required this.proposal,
    this.onTap,
    this.onFavoriteChanged,
    this.onVoteAction,
    this.readOnly = false,
  });

  @override
  State<ProposalBriefCard> createState() => _ProposalBriefCardState();
}

class _Author extends StatelessWidget {
  final String? author;

  const _Author({
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          ProfileAvatar(
            size: 32,
            username: author,
          ),
          Flexible(
            child: UsernameText(
              key: const Key('Author'),
              author,
              maxLines: 1,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
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
  final bool isTruncated;

  const _Description({required this.text, required this.isTruncated});

  @override
  Widget build(BuildContext context) {
    return Text(
      key: const Key('Description'),
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colors.textOnPrimaryLevel0,
      ),
      maxLines: isTruncated ? 3 : 5,
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

class _ProposalBriefCardState extends State<ProposalBriefCard> {
  late final WidgetStatesController _statesController;

  @override
  Widget build(BuildContext context) {
    final proposal = widget.proposal;

    final voteData = proposal is ProposalBriefVoting ? proposal.voteData : null;
    final onVoteAction = widget.onVoteAction;

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
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: ProposalBorder(
            publish: proposal.publish,
            statesController: _statesController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Topbar(
                    proposalRef: proposal.selfRef,
                    isFavorite: proposal.isFavorite,
                    onFavoriteChanged: widget.onFavoriteChanged,
                  ),
                  const SizedBox(height: 2),
                  _Category(
                    category: proposal.categoryName,
                  ),
                  const SizedBox(height: 4),
                  _Title(text: proposal.title),
                  _Author(author: proposal.author),
                  _FundsAndDuration(
                    funds: proposal.formattedFunds,
                    duration: proposal.duration,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _Description(
                      text: proposal.description,
                      isTruncated: voteData?.hasVoted ?? false,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProposalInfo(
                    publish: proposal.publish,
                    version: proposal.versionNumber,
                    updateDate: proposal.updateDate,
                    commentsCount: proposal.commentsCount,
                  ),
                  if (voteData?.hasVoted ?? false) const SizedBox(height: 12),
                  if (voteData != null && onVoteAction != null)
                    VoteButton(
                      data: voteData,
                      onSelected: onVoteAction,
                      readOnly: widget.readOnly,
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

class _ProposalInfo extends StatelessWidget {
  final ProposalPublish publish;
  final int version;
  final DateTime updateDate;
  final int? commentsCount;

  const _ProposalInfo({
    required this.publish,
    required this.version,
    required this.updateDate,
    required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (publish.isDraft) const DraftProposalChip() else const FinalProposalChip(),
        const SizedBox(width: 4),
        ProposalVersionChip(version: version.toString()),
        const SizedBox(width: 4),
        VoicesPlainTooltip(
          message: _tooltipMessage(context),
          child: DayMonthTimeText(
            dateTime: updateDate,
          ),
        ),
        const Spacer(),
        if (commentsCount case final commentsCount?)
          ProposalCommentsChip(
            commentsCount: commentsCount,
          ),
      ],
    );
  }

  String _tooltipMessage(BuildContext context) {
    final timezone = context.select<SessionCubit?, TimezonePreferences>(
      (value) => value?.state.settings.timezone ?? TimezonePreferences.local,
    );

    final effectiveData = switch (timezone) {
      TimezonePreferences.utc => updateDate.toUtc(),
      TimezonePreferences.local => updateDate.toLocal(),
    };
    final dt = DateFormatter.formatDateTimeParts(effectiveData, includeYear: true);

    return context.l10n.publishedOn(dt.date, dt.time);
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 88),
      child: Text(
        key: const Key('Title'),
        text,
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Topbar extends StatelessWidget {
  final DocumentRef proposalRef;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const _Topbar({
    required this.proposalRef,
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
            await ShareProposalDialog.show(context, ref: proposalRef);
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
