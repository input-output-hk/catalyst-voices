import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProposalNavigationPanel extends StatelessWidget {
  final VoicesNodeMenuController proposalSetupController;
  final List<VoicesNodeMenuItem> proposalSetupItems;

  const ProposalNavigationPanel({
    required this.proposalSetupController,
    required this.proposalSetupItems,
  });

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: 'Proposal navigation',
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Segments',
          body: Column(
            children: [
              VoicesNodeMenu(
                name: 'Proposal setup',
                controller: proposalSetupController,
                items: proposalSetupItems,
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

    proposalSetupController.selected = value;
  }

  void _updateSetupMenuExpand(bool value) {
    proposalSetupController.isExpanded = value;
  }
}
