import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CampaignBuilderPanel extends StatelessWidget {
  final VoicesNodeMenuController setupCampaignController;

  const CampaignBuilderPanel({
    required this.setupCampaignController,
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
                items: [
                  VoicesNodeMenuItem(id: 0, label: 'Other topic 1'),
                  VoicesNodeMenuItem(id: 1, label: 'Other topic 2'),
                  VoicesNodeMenuItem(id: 2, label: 'Other topic 3'),
                ],
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
