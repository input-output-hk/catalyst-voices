import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class MyProposals extends StatelessWidget {
  const MyProposals({super.key});

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
            height: 56,
            color: context.colors.primaryContainer,
          ),
          const _SubmittedForReviewHeader(
            maxCount: 5,
            submittedCount: 2,
          ),
          const _SharedForPublicHeader(),
          const _NotPublishedHeader(),
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

class _NotPublishedHeader extends StatelessWidget {
  const _NotPublishedHeader();

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.notPublished,
      info: '',
      learnMoreUrl: 'learnMoreUrl',
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
    );
  }
}
