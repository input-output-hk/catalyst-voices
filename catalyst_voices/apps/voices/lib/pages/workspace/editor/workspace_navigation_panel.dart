import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class WorkspaceNavigationPanel extends StatelessWidget {
  const WorkspaceNavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: context.l10n.workspaceProposalNavigation,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: context.l10n.workspaceProposalNavigationSegments,
          body: SectionsMenuListener(
            controller: SectionsControllerScope.of(context),
          ),
        ),
      ],
    );
  }
}
