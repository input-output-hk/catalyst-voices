import 'package:catalyst_voices/pages/workspace/editor/workspace_guidance_view.dart';
import 'package:catalyst_voices/widgets/cards/comment_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          body: const _GuidanceSelector(),
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

class _GuidanceSelector extends StatelessWidget {
  const _GuidanceSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceEditorBloc, WorkspaceEditorState,
        WorkspaceGuidance>(
      selector: (state) => state.guidance,
      builder: (context, state) {
        if (state.isNoneSelected) {
          return Text(context.l10n.selectASection);
        } else if (state.showEmptyState) {
          return Text(context.l10n.noGuidanceForThisSection);
        } else {
          return GuidanceView(state.guidances);
        }
      },
    );
  }
}
