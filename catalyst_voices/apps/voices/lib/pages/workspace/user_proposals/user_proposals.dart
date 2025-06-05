import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/user_proposals/user_proposal_section.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class UserProposals extends StatefulWidget {
  final List<Proposal> items;

  const UserProposals({super.key, required this.items});

  @override
  State<UserProposals> createState() => _UserProposalsState();
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

class _UserProposalsState extends State<UserProposals> {
  List<Proposal> get _draft => widget.items.where((e) => e.publish.isDraft).toList();
  List<Proposal> get _local => widget.items.where((e) => e.publish.isLocal).toList();
  List<Proposal> get _submitted => widget.items.where((e) => e.publish.isPublished).toList();

  @override
  Widget build(BuildContext context) {
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
            height: 24,
            color: context.colorScheme.primary,
          ),
          const SizedBox(height: 20),
          UserProposalSection(
            items: _submitted,
            emptyTextMessage: context.l10n.noFinalUserProposals,
            title: context.l10n.submittedForReview(
              _submitted.length,
              ProposalDocument.maxSubmittedProposalsPerUser,
            ),
            info: context.l10n.submittedForReviewInfoMarkdown,
            learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
          ),
          UserProposalSection(
            items: _draft,
            emptyTextMessage: context.l10n.noDraftUserProposals,
            title: context.l10n.sharedForPublicInProgress,
            info: context.l10n.sharedForPublicInfoMarkdown,
            learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
          ),
          UserProposalSection(
            items: _local,
            emptyTextMessage: context.l10n.noLocalUserProposals,
            title: context.l10n.notPublished,
            info: context.l10n.notPublishedInfoMarkdown,
            learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
          ),
        ],
      ),
    );
  }
}
