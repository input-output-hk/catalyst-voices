import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalSetupPanel extends StatelessWidget {
  const ProposalSetupPanel();

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: context.l10n.workspaceProposalSetup,
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
