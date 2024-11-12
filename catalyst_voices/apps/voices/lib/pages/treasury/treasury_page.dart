import 'package:catalyst_voices/pages/treasury/treasury_body.dart';
import 'package:catalyst_voices/pages/treasury/treasury_details_panel.dart';
import 'package:catalyst_voices/pages/treasury/treasury_navigation_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

const sections = [
  CampaignSetup(
    id: 0,
    steps: [
      DummyTopicStep(
        id: 0,
        sectionId: 0,
        isEditable: false,
      ),
      DummyTopicStep(id: 1, sectionId: 0),
      DummyTopicStep(id: 2, sectionId: 0),
      DummyTopicStep(id: 3, sectionId: 0),
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

  final List<SectionsListViewItem> _bodyItems = [];

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
      child: SpaceScaffold(
        left: const TreasuryNavigationPanel(),
        body: TreasuryBody(
          items: _bodyItems,
        ),
        right: const TreasuryDetailsPanel(),
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
