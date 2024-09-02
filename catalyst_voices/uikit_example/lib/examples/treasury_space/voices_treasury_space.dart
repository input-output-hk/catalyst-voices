import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/treasury_space/campaign_builder_panel.dart';
import 'package:uikit_example/examples/treasury_space/campaign_comments_panel.dart';
import 'package:uikit_example/examples/treasury_space/campaign_details.dart';
import 'package:uikit_example/examples/treasury_space/voices_treasury_drawer.dart';

final class CampaignSetupStep extends VoicesNodeMenuItem {
  final String desc;

  String get name => label;

  const CampaignSetupStep({
    required super.id,
    required String name,
    required this.desc,
  }) : super(label: name);
}

const _campaignSetupSteps = [
  CampaignSetupStep(
    id: 0,
    name: 'Campaign title',
    desc: 'F14 / Promote Social Entrepreneurs and'
        ' a longer title up-to 60 characters',
  ),
  CampaignSetupStep(
    id: 1,
    name: 'Other topic 1',
    desc: 'Other topic 1',
  ),
  CampaignSetupStep(
    id: 2,
    name: 'Other topic 2',
    desc: 'Other topic 2',
  ),
  CampaignSetupStep(
    id: 3,
    name: 'Other topic 3',
    desc: 'Other topic 3',
  ),
];

class VoicesTreasurySpace extends StatefulWidget {
  static const String route = '/treasury-space';

  const VoicesTreasurySpace({
    super.key,
  });

  @override
  State<VoicesTreasurySpace> createState() => _VoicesTreasurySpaceState();
}

class _VoicesTreasurySpaceState extends State<VoicesTreasurySpace> {
  final _setupCampaignController = VoicesNodeMenuController(
    VoicesNodeMenuData(
      selectedItemId: _campaignSetupSteps.first.id,
      isExpanded: true,
    ),
  );

  @override
  void dispose() {
    _setupCampaignController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(
        backgroundColor: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
      ),
      drawer: VoicesTreasuryDrawer(),
      body: SpaceContainer(
        left: CampaignBuilderPanel(
          setupCampaignController: _setupCampaignController,
          setupCampaignItems: _campaignSetupSteps,
        ),
        right: CampaignCommentsPanel(),
        child: CampaignDetails(
          campaignSetupController: _setupCampaignController,
          steps: _campaignSetupSteps,
        ),
      ),
    );
  }
}
