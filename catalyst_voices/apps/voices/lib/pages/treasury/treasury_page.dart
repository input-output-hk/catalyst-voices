import 'package:catalyst_voices/pages/treasury/campaign_builder_panel.dart';
import 'package:catalyst_voices/pages/treasury/campaign_comments_panel.dart';
import 'package:catalyst_voices/pages/treasury/campaign_details.dart';
import 'package:catalyst_voices/pages/treasury/campaign_segment_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

const _setupSegmentId = 'setup';

const _campaignBuilder = TreasuryCampaignBuilder(
  segments: [
    TreasuryCampaignSetup(
      id: _setupSegmentId,
      steps: [
        TreasuryCampaignTitle(id: 0, isEditable: true),
        TreasuryCampaignTopicX(id: 1, nr: 1),
        TreasuryCampaignTopicX(id: 2, nr: 2),
        TreasuryCampaignTopicX(id: 3, nr: 2),
      ],
    ),
  ],
);

class TreasuryPage extends StatefulWidget {
  const TreasuryPage({
    super.key,
  });

  @override
  State<TreasuryPage> createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
  @override
  Widget build(BuildContext context) {
    return CampaignControllerScope(
      builder: _buildSegmentController,
      child: const SpaceScaffold(
        left: CampaignBuilderPanel(
          builder: _campaignBuilder,
        ),
        right: CampaignCommentsPanel(),
        child: CampaignDetails(
          builder: _campaignBuilder,
        ),
      ),
    );
  }

  // Only creates initial controller one time
  CampaignController _buildSegmentController(Object segmentId) {
    final value = segmentId == _setupSegmentId
        ? const CampaignControllerStateData(
            selectedItemId: 0,
            isExpanded: true,
          )
        : const CampaignControllerStateData();

    return CampaignController(value);
  }
}
