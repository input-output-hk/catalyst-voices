import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/voices_leading_icon_card.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/text/day_at_time_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CreateProposalCard extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final List<String> categoryRequirements;
  final DateTime submissionCloseDate;

  const CreateProposalCard({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryRequirements,
    required this.submissionCloseDate,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesLeadingIconCard(
      icon: VoicesAssets.icons.documentAdd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.createProposal,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel0,
            ),
          ),
          Text(
            context.l10n.inObject(categoryName),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          _Requirements(requirements: categoryRequirements),
          const SizedBox(height: 24),
          _SubmissionCloseAt(submissionCloseDate),
          const SizedBox(height: 24),
          VoicesFilledButton(
            child: Text(
              context.l10n.startProposal,
            ),
            onTap: () {
              //TODO(LynxLynxx) Pass categoryId when implemented
              const ProposalBuilderDraftRoute().go(context);
            },
          ),
        ],
      ),
    );
  }
}

class _Requirements extends StatelessWidget {
  final List<String> requirements;

  const _Requirements({required this.requirements});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: requirements.isEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            context.l10n.categoryRequirements,
            style: context.textTheme.bodyMedium,
          ),
          ...requirements.map(_RequirementsText.new),
        ],
      ),
    );
  }
}

class _RequirementsText extends StatelessWidget {
  final String text;

  const _RequirementsText(this.text);

  @override
  Widget build(BuildContext context) {
    return AffixDecorator(
      prefix: VoicesAssets.icons.check.buildIcon(),
      child: Text(
        text,
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}

class _SubmissionCloseAt extends StatelessWidget {
  final DateTime dateTime;

  const _SubmissionCloseAt(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoicesAssets.icons.calendar.buildIcon(),
        const SizedBox(width: 14),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.proposalsSubmissionClose,
              style: context.textTheme.bodyMedium,
            ),
            DayAtTimeText(
              dateTime: dateTime,
              showTimezone: false,
            ),
          ],
        ),
      ],
    );
  }
}
