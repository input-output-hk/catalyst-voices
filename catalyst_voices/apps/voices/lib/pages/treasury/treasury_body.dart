import 'package:catalyst_voices/pages/treasury/steps/treasury_campaign_categories_step.dart';
import 'package:catalyst_voices/pages/treasury/steps/treasury_campaign_details_step.dart';
import 'package:catalyst_voices/pages/treasury/steps/treasury_campaign_stages_edit_step.dart';
import 'package:catalyst_voices/pages/treasury/steps/treasury_campaign_stages_view_step.dart';
import 'package:catalyst_voices/pages/treasury/steps/treasury_proposal_template_step.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TreasuryBody extends StatelessWidget {
  final ItemScrollController itemScrollController;

  const TreasuryBody({
    super.key,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionsListViewBuilder(
      builder: (context, value, child) {
        return SectionsListView<TreasurySection, TreasurySectionStep>(
          itemScrollController: itemScrollController,
          items: value,
          stepBuilder: (context, step) {
            switch (step) {
              case SetupCampaignDetailsStep():
                return TreasuryCampaignDetailsStep(step: step);
              case SetupCampaignStagesStep():
                return _TreasuryCampaignStagesStep(step: step);
              case SetupProposalTemplateStep():
                return TreasuryProposalTemplateStep(step: step);
              case SetupCampaignCategoriesStep():
                return TreasuryCampaignCategoriesStep(step: step);
            }
          },
        );
      },
    );
  }
}

class _TreasuryCampaignStagesStep extends StatelessWidget {
  final TreasurySectionStep step;

  const _TreasuryCampaignStagesStep({required this.step});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SectionsControllerScope.of(context),
      builder: (context, sectionsState, child) {
        final isEditing = sectionsState.isEditing(step.sectionStepId);
        return isEditing
            ? TreasuryCampaignStagesEditStep(step: step)
            : TreasuryCampaignStagesViewStep(step: step);
      },
    );
  }
}
