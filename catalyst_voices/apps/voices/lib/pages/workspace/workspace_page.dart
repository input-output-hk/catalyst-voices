import 'package:catalyst_voices/pages/workspace/rich_text/answer.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/bonus_mark_up.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/delivery_and_accountability.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/feasibility_checks.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/problem_statement.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/public_description.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/solution_statement.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/title.dart';
import 'package:catalyst_voices/pages/workspace/rich_text/value_for_money.dart';
import 'package:catalyst_voices/pages/workspace/workspace_body.dart';
import 'package:catalyst_voices/pages/workspace/workspace_navigation_panel.dart';
import 'package:catalyst_voices/pages/workspace/workspace_setup_panel.dart';
import 'package:catalyst_voices/widgets/containers/space_scaffold.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const sections = [
  ProposalSetup(
    id: 0,
    steps: [
      TitleStep(
        id: 0,
        sectionId: 0,
        data: DocumentJson(title),
      ),
    ],
  ),
  ProposalSummary(
    id: 1,
    steps: [
      ProblemStep(
        id: 0,
        sectionId: 1,
        data: DocumentJson(problemStatement),
        charsLimit: 200,
      ),
      SolutionStep(
        id: 1,
        sectionId: 1,
        data: DocumentJson(solutionStatement),
        charsLimit: 200,
      ),
      PublicDescriptionStep(
        id: 2,
        sectionId: 1,
        data: DocumentJson(publicDescription),
        charsLimit: 3000,
      ),
    ],
  ),
  ProposalSolution(
    id: 2,
    steps: [
      ProblemPerspectiveStep(
        id: 0,
        sectionId: 2,
        data: DocumentJson(answer),
        charsLimit: 200,
      ),
      PerspectiveRationaleStep(
        id: 1,
        sectionId: 2,
        data: DocumentJson(answer),
        charsLimit: 200,
      ),
      ProjectEngagementStep(
        id: 2,
        sectionId: 2,
        data: DocumentJson(answer),
        charsLimit: 200,
      ),
    ],
  ),
  ProposalImpact(
    id: 3,
    steps: [
      BonusMarkUpStep(
        id: 0,
        sectionId: 3,
        data: DocumentJson(bonusMarkUp),
        charsLimit: 900,
      ),
      ValueForMoneyStep(
        id: 1,
        sectionId: 3,
        data: DocumentJson(valueForMoney),
        charsLimit: 2600,
      ),
    ],
  ),
  CompatibilityAndFeasibility(
    id: 4,
    steps: [
      DeliveryAndAccountabilityStep(
        id: 0,
        sectionId: 4,
        data: DocumentJson(deliveryAndAccountability),
      ),
      FeasibilityChecksStep(
        id: 1,
        sectionId: 4,
        data: DocumentJson(feasibilityChecks),
      ),
    ],
  ),
];

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({
    super.key,
  });

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  late final SectionsController _sectionsController;
  late final ItemScrollController _bodyItemScrollController;

  final List<SectionsListViewItem> _bodyItems = [];

  @override
  void initState() {
    super.initState();

    _sectionsController = SectionsController();
    _bodyItemScrollController = ItemScrollController();

    _populateSections();
  }

  @override
  void dispose() {
    _sectionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionsControllerScope(
      controller: _sectionsController,
      child: SpaceScaffold(
        left: const WorkspaceNavigationPanel(),
        body: WorkspaceBody(
          items: _bodyItems,
          itemScrollController: _bodyItemScrollController,
        ),
        right: const WorkspaceSetupPanel(),
      ),
    );
  }

  void _populateSections() {
    final bodyItems = sections
        .expand<SectionsListViewItem>((element) => [element, ...element.steps])
        .toList();

    _bodyItems.addAll(bodyItems);

    _sectionsController.value = SectionsControllerState.initial(
      sections: sections,
    );
  }
}
