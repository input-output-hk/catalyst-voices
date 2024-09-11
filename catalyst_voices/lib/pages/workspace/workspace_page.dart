import 'package:catalyst_voices/pages/workspace/proposal_details.dart';
import 'package:catalyst_voices/pages/workspace/proposal_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/proposal_segment_controller.dart';
import 'package:catalyst_voices/pages/workspace/proposal_setup_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

const _setupSegmentId = 'setup';

final _proposalNavigation = WorkspaceProposalNavigation(
  segments: [
    WorkspaceProposalSetup(
      id: _setupSegmentId,
      steps: [
        WorkspaceProposalSegmentStep(id: 0, title: 'Title', description: 'd', isEditable: true),
        WorkspaceProposalSegmentStep(id: 1, title: 'Rich text', document: Document(), isEditable: true),
        WorkspaceProposalSegmentStep(id: 2, title: 'Other topic', description: 'Other topic', isEditable: false),
        WorkspaceProposalSegmentStep(id: 3, title: 'Other topic', description: 'Other topic', isEditable: false),
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
  @override
  Widget build(BuildContext context) {
    return ProposalControllerScope(
      builder: _buildSegmentController,
      child: SpaceScaffold(
        left: ProposalNavigationPanel(
          navigation: _proposalNavigation,
        ),
        right: ProposalSetupPanel(),
        child: ProposalDetails(
          navigation: _proposalNavigation,
        ),
      ),
    );
  }

  // Only creates initial controller one time
  ProposalController _buildSegmentController(Object segmentId) {
    final value = segmentId == _setupSegmentId
        ? ProposalControllerStateData(
      selectedItemId: 0,
      isExpanded: true,
    )
        : ProposalControllerStateData();

    return ProposalController(value);
  }
}
