import 'package:catalyst_voices/pages/workspace/workspace_guidance_view.dart';
import 'package:catalyst_voices/widgets/cards/comment_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

const List<Guidance> mockGuidance = [
  Guidance(
    title: 'Use a Compelling Hook or Unique Angle',
    description:
        '''Adding an element of intrigue or a unique approach can make your title stand out. For example, “Revolutionizing Urban Mobility with Eco-Friendly Innovation” not only describes the proposal but also piques curiosity.''',
    type: GuidanceType.tips,
    weight: 1,
  ),
  Guidance(
    title: 'Be Specific and Solution-Oriented',
    description:
        '''Use keywords that pinpoint the problem you’re solving or the opportunity you’re capitalizing on. A title like “Streamlining Supply Chains for Cost-Effective and Rapid Delivery” instantly tells the reader what the proposal aims to achieve.''',
    type: GuidanceType.mandatory,
    weight: 2,
  ),
  Guidance(
    title: 'Highlight the Benefit or Outcome',
    description:
        '''Make sure the reader can immediately see the value or the end result of your proposal. A title like “Boosting Engagement and Growth through Targeted Digital Strategies” puts the focus on the positive outcomes.''',
    type: GuidanceType.mandatory,
    weight: 1,
  ),
  Guidance(
    title: 'Education',
    description: 'Use keywords that pinpoint the problem yo',
    type: GuidanceType.education,
    weight: 1,
  ),
];

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
          body: SetupSectionListener(
            SectionsControllerScope.of(context),
          ),
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

class SetupSectionListener extends StatelessWidget {
  final SectionsController _controller;

  const SetupSectionListener(
    this._controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, _) {
        final activeStepId = value.activeStepId;
        final activeStepGuidances = value.activeStepGuidances;

        if (activeStepId == null) {
          return Text(context.l10n.selectASection);
        } else if (activeStepGuidances == null || activeStepGuidances.isEmpty) {
          return Text(context.l10n.noGuidanceForThisSection);
        } else {
          return GuidanceView(activeStepGuidances);
        }
      },
    );
  }
}
