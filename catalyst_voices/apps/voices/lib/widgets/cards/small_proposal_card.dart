import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card_widgets.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/text/day_month_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class SmallProposalCard extends StatelessWidget {
  final Proposal proposal;
  const SmallProposalCard({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.outlineBorder,
        ),
        borderRadius: BorderRadius.circular(8),
        color:
            proposal.publish.isPublished ? context.colors.iconsPrimary : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            proposal.category,
            style: context.textTheme.labelMedium?.copyWith(
              color: proposal.publish.isPublished
                  ? context.colors.primaryContainer
                  : context.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            proposal.title,
            style: context.textTheme.titleSmall?.copyWith(
              color: proposal.publish.isPublished
                  ? context.colors.textOnPrimaryWhite
                  : null,
            ),
          ),
          Offstage(
            offstage: !proposal.publish.isLocal,
            child: _NewIterationDetails(
              title: proposal.title,
              iteration: proposal.version,
              datetime: proposal.updateDate,
              id: proposal.id,
            ),
          ),
          const SizedBox(height: 12),
          // TODO(LynxLynxx): offstage if new local version is not published
          _Details(proposal: proposal),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final Proposal proposal;

  const _Details({
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = proposal.publish.isPublished;
    return Row(
      spacing: 4,
      children: [
        switch (proposal.publish) {
          ProposalPublish.publishedDraft => const DraftProposalChip(),
          ProposalPublish.submittedProposal =>
            const FinalProposalChip(onColorBackground: false),
          ProposalPublish.localDraft => const PrivateProposalChip(),
        },
        ProposalVersionChip(
          version: proposal.version.toString(),
          useInternalBackground: !isPublished,
        ),
        DayMonthTimeTextWithTooltip(
          datetime: proposal.updateDate,
          color: isPublished ? context.colors.textOnPrimaryWhite : null,
        ),
        const Spacer(),
        Offstage(
          offstage: proposal.commentsCount == 0,
          child: ProposalCommentsChip(
            commentsCount: proposal.commentsCount,
            useInternalBackground: !isPublished,
          ),
        ),
      ],
    );
  }
}

class _NewIterationDetails extends StatelessWidget {
  final String title;
  final int iteration;
  final DateTime datetime;
  final String id;
  const _NewIterationDetails({
    required this.title,
    required this.iteration,
    required this.datetime,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.colors.onSurfaceNeutralOpaqueLv1,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: AffixDecorator(
                  prefix: VoicesAssets.icons.documentText.buildIcon(
                    color: context.colors.textOnPrimaryLevel1,
                  ),
                  child: Text(
                    context.l10n.newIterationTitle(
                      iteration,
                      DateFormatter.formatDayMonthTime(datetime),
                      title,
                    ),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.textOnPrimaryLevel1,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              VoicesTextButton(
                child: Text(context.l10n.open),
                onTap: () {
                  // TODO(LynxLynxx): open proposal builder
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _WarningNewIteration(),
      ],
    );
  }
}

class _WarningNewIteration extends StatelessWidget {
  const _WarningNewIteration();

  @override
  Widget build(BuildContext context) {
    return AffixDecorator(
      prefix: VoicesAssets.icons.exclamation
          .buildIcon(size: 12, color: context.colors.iconsWarning),
      child: Text(
        'Consider publishing this newer iteration!',
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colors.iconsWarning,
        ),
      ),
    );
  }
}
