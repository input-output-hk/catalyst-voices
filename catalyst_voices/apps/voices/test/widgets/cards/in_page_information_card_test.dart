import 'package:catalyst_voices/widgets/cards/in_page_information_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  late ThemeData theme;
  late VoicesColorScheme voicesColors;

  final draftInformationTest = DraftCampaignInformation(
    date: DateTime(2024, 11, 20, 13, 00, 00),
    description: 'Draft Information Test',
  );

  final liveInformationTest = LiveCampaignInformation(
    date: DateTime(2024, 11, 20, 13, 00, 00),
    description: 'Live Information Test',
  );

  const completedInformationText = CompletedCampaignInformation(
    description: 'Completed Information Test',
  );

  setUp(() {
    theme = ThemeBuilder.buildTheme(
      brand: Brand.catalyst,
      brightness: Brightness.light,
    );
    voicesColors = const VoicesColorScheme.optional(
      outlineBorderVariant: Colors.red,
      elevationsOnSurfaceNeutralLv1White: Colors.blue,
    );
  });

  Widget buildTestWidget(InPageInformation information) {
    return Scaffold(
      body: SizedBox(
        width: 1000,
        child: InPageInformationCard(
          information: information,
        ),
      ),
    );
  }

  group('InPageInformationCard', () {
    testWidgets(
      'Renders correctly always display elements which are always render',
      (tester) async {
        await tester.pumpApp(
          buildTestWidget(completedInformationText),
          theme: theme,
          voicesColors: voicesColors,
        );

        await tester.pumpAndSettle();

        expect(find.byType(InPageInformationCard), findsOneWidget);
        expect(find.byType(CatalystSvgIcon), findsOneWidget);
      },
    );

    testWidgets('Renders correctly for draft information', (tester) async {
      await tester.pumpApp(
        buildTestWidget(draftInformationTest),
        theme: theme,
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(InPageInformationCard), findsOneWidget);
      expect(find.byType(Text), findsExactly(3));
      expect(find.byType(CatalystSvgIcon), findsExactly(2));
      expect(
        find.text('Campaign Staring Soon (Ready to deploy)'),
        findsOneWidget,
      );
      expect(find.text(draftInformationTest.description), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('Renders correctly for live information', (tester) async {
      await tester.pumpApp(
        buildTestWidget(liveInformationTest),
        theme: theme,
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(InPageInformationCard), findsOneWidget);
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
        theme: theme,
        voicesColors: voicesColors,
      );

      await tester.pumpAndSettle();

      expect(find.byType(InPageInformationCard), findsOneWidget);
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
