import 'package:catalyst_voices/pages/treasury/campaign_builder_panel.dart';
import 'package:catalyst_voices/pages/treasury/campaign_comments_panel.dart';
import 'package:catalyst_voices/pages/treasury/campaign_details.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

/*final class CampaignSetupStep extends VoicesNodeMenuItem {
  final String desc;

  const CampaignSetupStep({
    required super.id,
    required String name,
    required this.desc,
  }) : super(label: name);

  /// Just syntax sugar. Semantically it makes more sense to have `name`.
  String get name => label;
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
];*/

class TreasuryPage extends StatefulWidget {
  const TreasuryPage({
    super.key,
  });

  @override
  State<TreasuryPage> createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
  final _setupCampaignController = VoicesNodeMenuController();

  @override
  void dispose() {
    _setupCampaignController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpaceScaffold(
      left: CampaignBuilderPanel(
        setupCampaignController: _setupCampaignController,
        setupCampaignItems: [
          //
        ],
      ),
      right: CampaignCommentsPanel(),
      child: CampaignDetails(
        campaignSetupController: _setupCampaignController,
        steps: [
          //
        ],
      ),
    );
  }
}
