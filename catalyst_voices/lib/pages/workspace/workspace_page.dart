import 'package:catalyst_voices/pages/workspace/proposal_details.dart';
import 'package:catalyst_voices/pages/workspace/proposal_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/proposal_segment_controller.dart';
import 'package:catalyst_voices/pages/workspace/proposal_setup_panel.dart';
import 'package:catalyst_voices/pages/workspace/sample_rich_text.dart';
import 'package:catalyst_voices/pages/workspace/sample_rich_text2.dart';
import 'package:catalyst_voices/pages/workspace/sample_rich_text3.dart';
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
        const WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Title',
          description: 'F14 / Promote Social Entrepreneurs and a '
              'longer title up-to 60 characters',
          isEditable: true,
        ),
        WorkspaceProposalSegmentStep(
          id: 1,
          title: 'Rich text',
          document: Document.fromJson(sampleRichText),
          isEditable: true,
        ),
        WorkspaceProposalSegmentStep(
          id: 2,
          title: 'Other topic',
          document: Document.fromJson(sampleRichText2),
          isEditable: false,
        ),
        WorkspaceProposalSegmentStep(
          id: 3,
          title: 'Other topic',
          document: Document.fromJson(sampleRichText3),
          isEditable: false,
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
  @override
  Widget build(BuildContext context) {
    return ProposalControllerScope(
      builder: _buildSegmentController,
      child: SpaceScaffold(
        left: ProposalNavigationPanel(
          navigation: _proposalNavigation,
        ),
        right: const ProposalSetupPanel(),
        child: ProposalDetails(
          navigation: _proposalNavigation,
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
