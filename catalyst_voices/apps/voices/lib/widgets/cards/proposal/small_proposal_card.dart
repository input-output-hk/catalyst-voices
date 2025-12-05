import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/cards/proposal/proposal_card_widgets.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/text/day_month_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SmallProposalCard extends StatelessWidget {
  final UsersProposalOverview proposal;
  final bool showLatestLocal;

  const SmallProposalCard({
    super.key,
    required this.proposal,
    this.showLatestLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!proposal.publish.isLocal) {
          return ProposalRoute.fromRef(ref: proposal.id).push(context);
        } else if (!proposal.hasNewerLocalIteration && proposal.publish.isLocal) {
          return ProposalBuilderRoute.fromRef(ref: proposal.id).push(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colors.outlineBorder,
          ),
          borderRadius: BorderRadius.circular(8),
          color: proposal.publish.isPublished ? context.colors.iconsPrimary : null,
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
                color: proposal.publish.isPublished ? context.colors.textOnPrimaryWhite : null,
              ),
            ),
            Offstage(
              offstage: !proposal.hasNewerLocalIteration || !showLatestLocal,
              child: _NewIterationDetails(
                title: proposal.versions.latest.title,
                iteration: proposal.versions.latest.versionNumber,
                datetime: proposal.versions.latest.createdAt,
                ref: proposal.versions.latest.id,
              ),
            ),
            const SizedBox(height: 12),
            _Details(proposal: proposal),
          ],
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final UsersProposalOverview proposal;

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
          ProposalPublish.submittedProposal => const FinalProposalChip(onColorBackground: false),
          ProposalPublish.localDraft => const PrivateProposalChip(),
        },
        ProposalVersionChip(
          version: proposal.iteration.toString(),
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
  final DateTime? datetime;
  final DocumentRef ref;

  const _NewIterationDetails({
    required this.title,
    required this.iteration,
    required this.datetime,
    required this.ref,
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
                      DateFormatter.formatDayMonthTime(datetime ?? DateTimeExt.now()),
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
                  ProposalBuilderRoute.fromRef(ref: ref).go(context);
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
      prefix: VoicesAssets.icons.exclamation.buildIcon(
        size: 12,
        color: context.colors.iconsWarning,
      ),
      child: Text(
        'Consider publishing this newer iteration!',
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colors.iconsWarning,
        ),
      ),
    );
  }
}
