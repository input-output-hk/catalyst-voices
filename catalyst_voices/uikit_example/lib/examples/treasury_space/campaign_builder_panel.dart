import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CampaignBuilderPanel extends StatelessWidget {
  final VoicesNodeMenuController setupCampaignController;
  final List<VoicesNodeMenuItem> setupCampaignItems;

  const CampaignBuilderPanel({
    required this.setupCampaignController,
    required this.setupCampaignItems,
  });

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: 'Campaign builder',
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Segments',
          body: Column(
            children: [
              VoicesNodeMenu(
                name: 'Setup Campaign',
                controller: setupCampaignController,
                items: setupCampaignItems,
                onSelectionChanged: _updateSetupMenuSelection,
                onExpandChanged: _updateSetupMenuExpand,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateSetupMenuSelection(int? value) {
    if (value == null) {
      return;
    }

    setupCampaignController.selected = value;
  }

  void _updateSetupMenuExpand(bool value) {
    setupCampaignController.isExpanded = value;
  }
}
