import 'package:catalyst_voices/widgets/cards/campaign_stage_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  late VoicesColorScheme voicesColors;

  final draftCampaignTest = CampaignInfo(
    id: SignedDocumentRef.generateFirstRef(),
    stage: CampaignStage.draft,
    startDate: DateTime(2024, 11, 19, 13),
    endDate: DateTime(2024, 11, 20, 13),
    description: 'Draft Campaign Test',
  );

  final scheduledCampaignTest = CampaignInfo(
    id: SignedDocumentRef.generateFirstRef(),
    stage: CampaignStage.scheduled,
    startDate: DateTime(2024, 11, 19, 13),
    endDate: DateTime(2024, 11, 20, 13),
    description: 'Scheduled Campaign Test',
  );

  final liveCampaignTest = CampaignInfo(
    id: SignedDocumentRef.generateFirstRef(),
    stage: CampaignStage.live,
    startDate: DateTime(2024, 11, 19, 13),
    endDate: DateTime(2024, 11, 20, 13),
    description: 'Live Campaign Test',
  );

  final completedCampaignText = CampaignInfo(
    id: SignedDocumentRef.generateFirstRef(),
    stage: CampaignStage.completed,
    startDate: DateTime(2024, 11, 19, 13),
    endDate: DateTime(2024, 11, 20, 13),
    description: 'Completed Campaign Test',
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
    testWidgets('Renders all elements correctly', (tester) async {
      await tester.pumpApp(
        buildTestWidget(completedCampaignText),
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(CampaignStageCard), findsOneWidget);
      expect(find.byType(CatalystSvgIcon), findsOneWidget);
    });

    testWidgets('Renders correctly for draft campaign', (tester) async {
      await tester.pumpApp(
        buildTestWidget(draftCampaignTest),
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
      expect(find.text(draftCampaignTest.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('Renders correctly for scheduled campaign', (tester) async {
      await tester.pumpApp(
        buildTestWidget(scheduledCampaignTest),
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
      expect(find.text(scheduledCampaignTest.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('Renders correctly for live campaign', (tester) async {
      await tester.pumpApp(
        buildTestWidget(liveCampaignTest),
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
      expect(find.text(liveCampaignTest.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('View proposals'), findsOneWidget);
    });

    testWidgets('Renders correctly for completed campaign', (tester) async {
      await tester.pumpApp(
        buildTestWidget(completedCampaignText),
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
      expect(find.text(completedCampaignText.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('View Voting Results'), findsOneWidget);
    });
  });
}
