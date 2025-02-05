import 'package:catalyst_voices/pages/treasury/treasury_body.dart';
import 'package:catalyst_voices/pages/treasury/treasury_details_panel.dart';
import 'package:catalyst_voices/pages/treasury/treasury_navigation_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const _segments = [
  TreasurySegment(
    id: NodeId(''),
    sections: [
      SetupCampaignDetails(id: NodeId('0')),
      SetupCampaignStages(id: NodeId('1')),
      SetupProposalTemplate(id: NodeId('2')),
      SetupCampaignCategories(id: NodeId('3')),
    ],
  ),
];

class TreasuryPage extends StatefulWidget {
  const TreasuryPage({super.key});

  @override
  State<TreasuryPage> createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
  late final SegmentsController _segmentsController;
  late final ItemScrollController _bodyItemScrollController;

  @override
  void initState() {
    super.initState();

    _segmentsController = SegmentsController();
    _bodyItemScrollController = ItemScrollController();

    _segmentsController.attachItemsScrollController(_bodyItemScrollController);

    _populateSections();
  }

  @override
  void dispose() {
    _segmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SegmentsControllerScope(
      controller: _segmentsController,
      child: SpaceScaffold(
        left: const TreasuryNavigationPanel(),
        body: TreasuryBody(
          itemScrollController: _bodyItemScrollController,
        ),
        right: const TreasuryDetailsPanel(),
      ),
    );
  }

  void _populateSections() {
    _segmentsController.value = SegmentsControllerState.initial(
      segments: _segments,
    );
  }
}
