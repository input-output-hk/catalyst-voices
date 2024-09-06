import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProposalSetupPanel extends StatelessWidget {
  const ProposalSetupPanel();

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: 'Proposal Setup',
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Guidance',
          body: Offstage(),
        ),
        SpaceSidePanelTab(
          name: 'Comments',
          body: Offstage(),
        ),
        SpaceSidePanelTab(
          name: 'Actions',
          body: Offstage(),
        ),
      ],
    );
  }
}
