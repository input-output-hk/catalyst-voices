import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/category/widgets/card_information/submission_close_date_category_detail_text.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/cards/voices_leading_icon_card.dart';
import 'package:catalyst_voices/widgets/list/category_requirements_list.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateProposalCard extends StatelessWidget {
  final SignedDocumentRef categoryRef;
  final String categoryName;
  final List<String> categoryDos;
  final List<String> categoryDonts;

  const CreateProposalCard({
    super.key,
    required this.categoryRef,
    required this.categoryName,
    required this.categoryDos,
    required this.categoryDonts,
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
          const SubmissionCloseDateCategoryDetailText(),
          const SizedBox(height: 24),
          CreateProposalButton(categoryRef: categoryRef),
        ],
      ),
    );
  }
}
