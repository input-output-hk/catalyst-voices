import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/cards/voices_leading_icon_card.dart';
import 'package:catalyst_voices/widgets/list/category_requirements_list.dart';
import 'package:catalyst_voices/widgets/text/day_at_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateProposalCard extends StatelessWidget {
  final SignedDocumentRef categoryRef;
  final String categoryName;
  final List<String> categoryDos;
  final List<String> categoryDonts;
  final DateTime submissionCloseDate;

  const CreateProposalCard({
    super.key,
    required this.categoryRef,
    required this.categoryName,
    required this.categoryDos,
    required this.categoryDonts,
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
          CategoryRequirementsList(
            dos: categoryDos,
            donts: categoryDonts,
          ),
          const SizedBox(height: 24),
          _SubmissionCloseAt(submissionCloseDate),
          const SizedBox(height: 24),
          CreateProposalButton(categoryRef: categoryRef),
        ],
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
              showTimezone: true,
            ),
          ],
        ),
      ],
    );
  }
}
