import 'package:catalyst_voices/pages/treasury/treasury_body.dart';
import 'package:catalyst_voices/pages/treasury/treasury_details_panel.dart';
import 'package:catalyst_voices/pages/treasury/treasury_navigation_panel.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

const sections = [
  CampaignSetup(
    id: 0,
    steps: [
      DummyTopicStep(id: 0, isEditable: false),
      DummyTopicStep(id: 1),
      DummyTopicStep(id: 2),
      DummyTopicStep(id: 3),
    ],
  ),
];

class TreasuryPage extends StatefulWidget {
  const TreasuryPage({
    super.key,
  });

  @override
  State<TreasuryPage> createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
  late final SectionsController _sectionsController;

  @override
  void initState() {
    super.initState();

    _sectionsController = SectionsController();

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
      child: const SpaceScaffold(
        left: TreasuryNavigationPanel(),
        body: TreasuryBody(sections: sections),
        right: TreasuryDetailsPanel(),
      ),
    );
  }

  void _populateSections() {
    final section = sections.firstOrNull;
    final step = section?.steps.firstOrNull;

    _sectionsController.value = SectionsControllerState(
      sections: sections,
      openedSections: sections.map((e) => e.id).toSet(),
      selectedStep: section != null && step != null
          ? (sectionId: section.id, stepId: step.id)
          : null,
    );
  }
}
