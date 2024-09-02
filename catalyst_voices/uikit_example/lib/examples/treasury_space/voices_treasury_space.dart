import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/examples/treasury_space/campaign_builder_panel.dart';
import 'package:uikit_example/examples/treasury_space/campaign_comments_panel.dart';
import 'package:uikit_example/examples/treasury_space/campaign_details.dart';

class VoicesTreasurySpace extends StatefulWidget {
  static const String route = '/treasury-space';

  const VoicesTreasurySpace({
    super.key,
  });

  @override
  State<VoicesTreasurySpace> createState() => _VoicesTreasurySpaceState();
}

class _VoicesTreasurySpaceState extends State<VoicesTreasurySpace> {
  final _setupCampaignController = VoicesNodeMenuController(selected: 0);

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
      drawer: const VoicesDrawer(children: []),
      body: SpaceContainer(
        left: CampaignBuilderPanel(
          setupCampaignController: _setupCampaignController,
        ),
        right: CampaignCommentsPanel(),
        child: CampaignDetails(),
      ),
    );
  }
}
