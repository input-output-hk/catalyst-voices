import 'package:catalyst_voices/pages/workspace/proposal_details.dart';
import 'package:catalyst_voices/pages/workspace/proposal_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/proposal_segment_controller.dart';
import 'package:catalyst_voices/pages/workspace/proposal_setup_panel.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/answer.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/bonus_mark_up.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/delivery_and_accountability.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/feasibility_checks.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/problem_statement.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/public_description.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/solution_statement.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/title.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/value_for_money.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

const _setupSegmentId = 'setup';
const _summarySegmentId = 'summary';
const _solutionSegmentId = 'solution';
const _impactSegmentId = 'impact';
const _capabilityAndFeasibilitySegmentId = 'capabilityAndFeasibility';

final _proposalNavigation = WorkspaceProposalNavigation(
  segments: [
    WorkspaceProposalSetup(
      id: _setupSegmentId,
      steps: [
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Title',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(title),
          ),
        ),
      ],
    ),
    WorkspaceProposalSummary(
      id: _summarySegmentId,
      steps: [
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Problem statement',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(problemStatement),
            charsLimit: 200,
          ),
        ),
        WorkspaceProposalSegmentStep(
          id: 1,
          title: 'Solution statement',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(solutionStatement),
            charsLimit: 200,
          ),
        ),
        WorkspaceProposalSegmentStep(
          id: 2,
          title: 'Public description',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(publicDescription),
            charsLimit: 3000,
          ),
        ),
      ],
    ),
    WorkspaceProposalSolution(
      id: _solutionSegmentId,
      steps: [
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Problem perspective',
          titleInDetails:
              "What is your perspective on the problem you're solving?",
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(answer),
            charsLimit: 200,
          ),
        ),
        WorkspaceProposalSegmentStep(
          id: 1,
          title: 'Perspective rationale',
          titleInDetails: 'Why did you choose this perspective?',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(answer),
            charsLimit: 200,
          ),
        ),
        WorkspaceProposalSegmentStep(
          id: 2,
          title: 'Project engagement',
          titleInDetails: 'Who will your project engage?',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(answer),
            charsLimit: 200,
          ),
        ),
      ],
    ),
    WorkspaceProposalImpact(
      id: _impactSegmentId,
      steps: [
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Bonus mark-up',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(bonusMarkUp),
            charsLimit: 900,
          ),
        ),
        WorkspaceProposalSegmentStep(
          id: 1,
          title: 'Value for Money',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(valueForMoney),
            charsLimit: 2600,
          ),
        ),
      ],
    ),
    WorkspaceProposalCapabilityAndFeasibility(
      id: _capabilityAndFeasibilitySegmentId,
      steps: [
        WorkspaceProposalSegmentStep(
          id: 0,
          title: 'Delivery & Accountability',
          titleInDetails:
              'How do you proof trust and accountability for your project?',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(deliveryAndAccountability),
          ),
        ),
        WorkspaceProposalSegmentStep(
          id: 1,
          title: 'Feasibility checks',
          titleInDetails: 'How will you check if your approach will work?',
          richTextParams: RichTextParams(
            documentJson: const DocumentJson(feasibilityChecks),
          ),
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
