import 'package:catalyst_voices/widgets/cards/category_proposals_details_card.dart';
import 'package:catalyst_voices/widgets/cards/create_proposal_card.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CardInformation extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;
  final ScrollController? scrollController;
  final bool isActiveProposer;
  final EdgeInsets padding;
  final BoxConstraints boxConstraints;

  const CardInformation({
    super.key,
    required this.category,
    this.scrollController,
    this.padding = const EdgeInsets.only(top: 96, bottom: 42),
    required this.isActiveProposer,
    this.boxConstraints = const BoxConstraints.tightFor(width: 300),
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: boxConstraints,
      child: ListView(
        controller: scrollController,
        padding: padding,
        children: [
          CategoryProposalsDetailsCard(
            categoryRef: category.ref,
            categoryName: category.formattedName,
            categoryFinalProposalsCount: category.finalProposalsCount,
          ),
          const SizedBox(height: 16),
          Offstage(
            offstage: !isActiveProposer,
            child: CreateProposalCard(
              categoryRef: category.ref,
              categoryName: category.formattedName,
              categoryDos: category.dos,
              categoryDonts: category.donts,
              submissionCloseDate: category.submissionCloseDate,
            ),
          ),
        ],
      ),
    );
  }
}
