import 'package:catalyst_voices/pages/workspace/proposal_details.dart';
import 'package:catalyst_voices/pages/workspace/proposal_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/proposal_segment_controller.dart';
import 'package:catalyst_voices/pages/workspace/proposal_setup_panel.dart';
import 'package:catalyst_voices/pages/workspace/sample_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

const _setupSegmentId = 'setup';

const _proposalNavigation = WorkspaceProposalNavigation(
  segments: [
    WorkspaceProposalSetup(
      id: _setupSegmentId,
      steps: [
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Rich text',
          documentJson: DocumentJson(sampleRichText),
          isEditable: true,
        ),
      ],
    ),
  ],
);

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({
    super.key,
  });

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  // This future is here only because we're loading too much at once
  // and drawer animation hangs for sec.
  //
  // Should be deleted later with normal data source
  final _delayFuture = Future<void>.delayed(const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return ProposalControllerScope(
      builder: _buildSegmentController,
      child: SpaceScaffold(
        left: const ProposalNavigationPanel(
          navigation: _proposalNavigation,
        ),
        right: const ProposalSetupPanel(),
        child: FutureBuilder(
          future: _delayFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox.shrink();
            }

            return const ProposalDetails(
              navigation: _proposalNavigation,
            );
          },
        ),
      ),
    );
  }

  // Only creates initial controller one time
  ProposalController _buildSegmentController(Object segmentId) {
    final value = segmentId == _setupSegmentId
        ? const ProposalControllerStateData(
            selectedItemId: 0,
            isExpanded: true,
          )
        : const ProposalControllerStateData();

    return ProposalController(value);
  }
}
