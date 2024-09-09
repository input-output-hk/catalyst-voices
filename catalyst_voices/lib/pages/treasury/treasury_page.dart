import 'package:catalyst_voices/pages/treasury/campaign_builder_panel.dart';
import 'package:catalyst_voices/pages/treasury/campaign_comments_panel.dart';
import 'package:catalyst_voices/pages/treasury/campaign_details.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

const _setupSegmentId = 'setup';

final _campaignBuilder = TreasuryCampaignBuilder(
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
  // TODO(damian-molinski): Build VoicesNodeMenuControllerScope widget
  final _controllers = <String, VoicesNodeMenuController>{
    _setupSegmentId: VoicesNodeMenuController(),
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpaceScaffold(
      left: CampaignBuilderPanel(
        builder: _campaignBuilder,
        stepsControllers: _controllers,
      ),
      right: CampaignCommentsPanel(),
      child: CampaignDetails(
        builder: _campaignBuilder,
        stepsControllers: _controllers,
      ),
    );
  }
}
