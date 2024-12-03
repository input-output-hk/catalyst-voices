import 'package:catalyst_voices/widgets/cards/comment_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceSetupPanel extends StatelessWidget {
  const WorkspaceSetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: false,
      name: context.l10n.workspaceProposalSetup,
      onCollapseTap: () {},
      tabs: [
        SpaceSidePanelTab(
          name: 'Guidance',
          body: const _SetupSectionListener(),
        ),
        SpaceSidePanelTab(
          name: 'Comments',
          body: CommentCard(
            comment: Comment(
              text: 'Lacks clarity on key objectives and measurable outcomes.',
              date: DateTime.now(),
              userName: 'Community Member',
            ),
          ),
        ),
        //No actions for now
        // SpaceSidePanelTab(
        //   name: 'Actions',
        //   body: const Offstage(),
        // ),
      ],
    );
  }
}

// TODO(damian): Read bloc state
class _SetupSectionListener extends StatelessWidget {
  const _SetupSectionListener();

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.noGuidanceForThisSection);
    // final activeStepId = value.activeStepId;
    // final activeStepGuidances = value.activeStepGuidances;
    //
    // if (activeStepId == null) {
    //   return Text(context.l10n.selectASection);
    // } else if (activeStepGuidances == null || activeStepGuidances.isEmpty) {
    //   return Text(context.l10n.noGuidanceForThisSection);
    // } else {
    //   return GuidanceView(activeStepGuidances);
    // }
  }
}
