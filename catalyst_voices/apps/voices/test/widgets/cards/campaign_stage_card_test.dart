import 'package:catalyst_voices/widgets/cards/campaign_stage_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  late VoicesColorScheme voicesColors;

  final draftInformationTest = DraftCampaignInfo(
    id: 'campaign_draft',
    startDate: DateTime(2024, 11, 20, 13, 00, 00),
    description: 'Draft Information Test',
  );

  final liveInformationTest = LiveCampaignInfo(
    id: 'campaign_live',
    startDate: DateTime(2024, 11, 20, 13, 00, 00),
    description: 'Live Information Test',
  );

  const completedInformationText = CompletedCampaignInfo(
    id: 'campaign_completed',
    description: 'Completed Information Test',
  );

  setUp(() {
    voicesColors = const VoicesColorScheme.optional(
      outlineBorderVariant: Colors.red,
      elevationsOnSurfaceNeutralLv1White: Colors.blue,
    );
  });

  Widget buildTestWidget(CampaignInfo campaign) {
    return Scaffold(
      body: SizedBox(
        width: 1000,
        child: CampaignStageCard(
          campaign: campaign,
        ),
      ),
    );
  }

  group(CampaignStageCard, () {
    testWidgets(
      'Renders correctly always display elements which are always render',
      (tester) async {
        await tester.pumpApp(
          buildTestWidget(completedInformationText),
          voicesColors: voicesColors,
        );

        await tester.pumpAndSettle();

        expect(find.byType(CampaignStageCard), findsOneWidget);
        expect(find.byType(CatalystSvgIcon), findsOneWidget);
      },
    );

    testWidgets('Renders correctly for draft information', (tester) async {
      await tester.pumpApp(
        buildTestWidget(draftInformationTest),
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(CampaignStageCard), findsOneWidget);
      expect(find.byType(Text), findsExactly(3));
      expect(find.byType(CatalystSvgIcon), findsExactly(2));
      expect(
        find.text('Campaign Starting Soon (Ready to deploy)'),
        findsOneWidget,
      );
      expect(find.text(draftInformationTest.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('Renders correctly for live information', (tester) async {
      await tester.pumpApp(
        buildTestWidget(liveInformationTest),
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(CampaignStageCard), findsOneWidget);
      expect(find.byType(Text), findsExactly(4));
      expect(find.byType(CatalystSvgIcon), findsExactly(2));
      expect(
        find.text('Campaign Is Live (Published)'),
        findsOneWidget,
      );
      expect(find.text(liveInformationTest.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('View proposals'), findsOneWidget);
    });

    testWidgets('Renders correctly for completed information', (tester) async {
      await tester.pumpApp(
        buildTestWidget(completedInformationText),
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(CampaignStageCard), findsOneWidget);
      expect(find.byType(Text), findsExactly(3));
      expect(find.byType(CatalystSvgIcon), findsOneWidget);
      expect(
        find.text('Campaign Concluded, Result are in!'),
        findsOneWidget,
      );
      expect(find.text(completedInformationText.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('View Voting Results'), findsOneWidget);
    });
  });
}
