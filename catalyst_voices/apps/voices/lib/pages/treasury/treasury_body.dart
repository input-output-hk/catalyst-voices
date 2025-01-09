import 'package:catalyst_voices/pages/treasury/sections/treasury_campaign_categories_step.dart';
import 'package:catalyst_voices/pages/treasury/sections/treasury_campaign_details_tile.dart';
import 'package:catalyst_voices/pages/treasury/sections/treasury_campaign_stages_edit_tile.dart';
import 'package:catalyst_voices/pages/treasury/sections/treasury_campaign_stages_view_tile.dart';
import 'package:catalyst_voices/pages/treasury/sections/treasury_proposal_template_tile.dart';
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
    return SegmentsListViewBuilder(
      builder: (context, value, child) {
        return SegmentsListView<TreasurySegment, TreasurySection>(
          itemScrollController: itemScrollController,
          items: value,
          sectionBuilder: (context, data) {
            switch (data) {
              case SetupCampaignDetails():
                return TreasuryCampaignDetailsTile(data);
              case SetupCampaignStages():
                return _TreasuryCampaignStagesSection(data);
              case SetupProposalTemplate():
                return TreasuryProposalTemplateTile(data);
              case SetupCampaignCategories():
                return TreasuryCampaignCategoriesTile(data);
            }
          },
        );
      },
    );
  }
}

class _TreasuryCampaignStagesSection extends StatelessWidget {
  final TreasurySection data;

  const _TreasuryCampaignStagesSection(this.data);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, sectionsState, child) {
        final isEditing = sectionsState.isEditing(data.id);
        return isEditing
            ? TreasuryCampaignStagesEditTile(data)
            : TreasuryCampaignStagesViewTile(data);
      },
    );
  }
}
