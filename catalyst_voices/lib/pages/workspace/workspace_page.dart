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
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Title',
          description: 'F14 / Promote Social Entrepreneurs and a '
              'longer title up-to 60 characters',
          isEditable: true,
        ),
        WorkspaceProposalSegmentStep(
          id: 1,
          title: 'Rich text',
          document: Document.fromJson(_textSample),
          isEditable: true,
        ),
        WorkspaceProposalSegmentStep(
            id: 2,
            title: 'Other topic',
            description: 'Other topic',
            isEditable: false),
        WorkspaceProposalSegmentStep(
            id: 3,
            title: 'Other topic',
            description: 'Other topic',
            isEditable: false),
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

const _textSample = [
  {
    "insert": {
      "image":
          'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png'
    },
    "attributes": {"style": "width: 181.764; height: 140; "}
  },
  {"insert": "\n\n"},
  {
    "insert": "Legend Tells About Amakuni The Great Smith",
    "attributes": {"bold": true}
  },
  {"insert": "\n\nAn ancient legend confirms "},
  {
    "insert": "Amakuni as the Father of the Samurai Sword. Amakuni",
    "attributes": {"bold": true}
  },
  {"insert": " and his son, "},
  {
    "insert": "Amakura",
    "attributes": {"italic": true}
  },
  {
    "insert":
        ", were the prominent smiths who led a team of armorers, employed by Emperor Mommu (683-707) to make swords for his army of warriors. Later his son, Amakura continued his father's "
  },
  {
    "insert": "great work",
    "attributes": {"italic": true}
  },
  {"insert": ".\n\n"},
  {
    "insert": "Amakura",
    "attributes": {"italic": true}
  },
  {
    "insert": "\n",
    "attributes": {"list": "bullet"}
  },
  {
    "insert": "Amakuro",
    "attributes": {"italic": true}
  },
  {
    "insert": "\n",
    "attributes": {"list": "bullet"}
  },
  {
    "insert": "Amakuri",
    "attributes": {"italic": true}
  },
  {
    "insert": "\n",
    "attributes": {"list": "bullet"}
  },
  {"insert": "\n"},
  {
    "insert": "Sword 1",
    "attributes": {"italic": true}
  },
  {
    "insert": "\n",
    "attributes": {"list": "ordered"}
  },
  {
    "insert": "Sword 2",
    "attributes": {"italic": true}
  },
  {
    "insert": "\n",
    "attributes": {"list": "ordered"}
  }
];
