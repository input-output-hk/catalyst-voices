import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/workspace_proposal_card.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class UserProposals extends StatelessWidget {
  final List<Proposal> items;

  const UserProposals({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final submitted = items
        .where((item) => item.publish == ProposalPublish.submittedProposal)
        .toList();
    final publicDraft = items
        .where((item) => item.publish == ProposalPublish.publishedDraft)
        .toList();
    final localDraft = items
        .where((item) => item.publish == ProposalPublish.localDraft)
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          VoicesDivider(
            indent: 0,
            endIndent: 0,
            height: 56,
            color: context.colors.primaryContainer,
          ),
          _SubmittedForReviewHeader(
            maxCount: 5,
            submittedCount: submitted.length,
          ),
          _ListOfProposals(
            items: submitted,
            emptyTextMessage: context.l10n.noFinalUserProposals,
          ),
          const _SharedForPublicHeader(),
          _ListOfProposals(
            items: publicDraft,
            emptyTextMessage: context.l10n.noDraftUserProposals,
          ),
          const _NotPublishedHeader(),
          _ListOfProposals(
            items: localDraft,
            emptyTextMessage: context.l10n.noLocalUserProposals,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.myProposals,
      style: context.textTheme.headlineSmall,
    );
  }
}

class _ListOfProposals extends StatelessWidget {
  final List<Proposal> items;
  final String emptyTextMessage;

  const _ListOfProposals({
    required this.items,
    required this.emptyTextMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(
        title: emptyTextMessage,
        description: context.l10n.emptyUserProposalDescriptionHelp,
      );
    } else {
      return Column(
        children: items
            .map(
              (e) => WorkspaceProposalCard(
                key: ValueKey(e.selfRef),
                proposal: e,
              ),
            )
            .toList(),
      );
    }
  }
}

class _NotPublishedHeader extends StatelessWidget {
  const _NotPublishedHeader();

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.notPublished,
      info: '',
      learnMoreUrl: 'learnMoreUrl',
      // TODO(LynxLynxx): update when we get info from designers
    );
  }
}

class _SharedForPublicHeader extends StatelessWidget {
  const _SharedForPublicHeader();

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.sharedForPublicInProgress,
      info: 'info',
      learnMoreUrl: 'learnMoreUrl',
      // TODO(LynxLynxx): update when we get info from designers
    );
  }
}

class _SubmittedForReviewHeader extends StatelessWidget {
  final int maxCount;
  final int submittedCount;
  const _SubmittedForReviewHeader({
    required this.maxCount,
    required this.submittedCount,
  });

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.submittedForReview(submittedCount, maxCount),
      info: 'Info',
      learnMoreUrl: '',
      // TODO(LynxLynxx): update when we get info from designers
    );
  }
}
