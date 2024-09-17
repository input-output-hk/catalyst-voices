import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalSetupPanel extends StatelessWidget {
  const ProposalSetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: context.l10n.workspaceProposalSetup,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Guidance',
          body: const Offstage(),
        ),
        SpaceSidePanelTab(
          name: 'Comments',
          body: const Offstage(),
        ),
        SpaceSidePanelTab(
          name: 'Actions',
          body: const Offstage(),
        ),
      ],
    );
  }
}
