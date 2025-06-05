import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline.dart';
import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices_brands/src/themes/catalyst.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide CampaignTimeline;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CampaignTimeline, () {
    const cardHeight = 160.0;
    const expandedCardHeight = 300.0;

    final timeline = DateRange(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(days: 7)),
    );

    final timelineItems = [
      CampaignTimelineViewModel(
        title: 'Test Title 1',
        description: 'Test Description 1',
        timeline: timeline,
        stage: CampaignTimelineStage.proposalSubmission,
      ),
      CampaignTimelineViewModel(
        title: 'Test Title 2',
        description: 'Test Description 2',
        timeline: DateRange(
          from: DateTime.now().add(const Duration(days: 8)),
          to: DateTime.now().add(const Duration(days: 15)),
        ),
        stage: CampaignTimelineStage.proposalSubmission,
      ),
    ];

    testWidgets(
      'renders correctly with multiple timeline items in discovery placement',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 160));

        final widget = Center(
          child: SizedBox(
            width: 1100,
            child: CampaignTimeline(
              timelineItems: timelineItems,
            ),
          ),
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Title 1'), findsOneWidget);
        expect(find.text('Test Title 2'), findsOneWidget);
        expect(find.text('Test Description 1'), findsNothing);
        expect(find.text('Test Description 2'), findsNothing);

        final initialHeight = tester
            .getSize(
              find.byType(CampaignTimeline),
            )
            .height;
        expect(initialHeight, cardHeight);

        expect(
          tester.takeException(),
          null,
          reason: 'Should not have any layout overflow',
        );
      },
    );

    testWidgets(
      'renders correctly with multiple timeline items in workspace placement',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        final widget = Center(
          child: SizedBox(
            width: 1100,
            child: CampaignTimeline(
              timelineItems: timelineItems,
            ),
          ),
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Title 1'), findsOneWidget);
        expect(find.text('Test Title 2'), findsOneWidget);
        expect(find.text('Test Description 1'), findsNothing);
        expect(find.text('Test Description 2'), findsNothing);

        // Add verification for overflow
        expect(
          tester.takeException(),
          null,
          reason: 'Should not have any layout overflow',
        );
      },
    );

    testWidgets(
      'changes height and shows description when a card is expanded',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        final widget = Center(
          child: SizedBox(
            width: 1100,
            child: CampaignTimeline(
              timelineItems: timelineItems,
            ),
          ),
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final initialHeight = tester.getSize(find.byType(CampaignTimelineCard).first).height;
        expect(initialHeight, cardHeight);
        expect(find.text('Test Description 1'), findsNothing);

        await tester.tap(find.byType(CampaignTimelineCard).first);
        await tester.pumpAndSettle();

        await tester.binding.setSurfaceSize(const Size(1200, expandedCardHeight));
        await tester.pumpAndSettle();

        expect(find.text('Test Description 1'), findsOneWidget);
        expect(find.text('Test Description 2'), findsNothing);
      },
    );

    testWidgets(
      'handles horizontal scroll correctly',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        final widget = Center(
          child: SizedBox(
            width: 1100,
            child: CampaignTimeline(
              timelineItems: List.generate(
                5,
                (index) => CampaignTimelineViewModel(
                  title: 'Title $index',
                  description: 'Description $index',
                  timeline: timeline,
                  stage: CampaignTimelineStage.proposalSubmission,
                ),
              ),
            ),
          ),
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final scrollable = find.byType(SingleChildScrollView);
        final initialPosition = tester.getTopLeft(find.text('Title 0'));

        await tester.drag(scrollable, const Offset(-300, 0));
        await tester.pumpAndSettle();

        final finalPosition = tester.getTopLeft(find.text('Title 0'));
        expect(finalPosition.dx, lessThan(initialPosition.dx));
      },
    );

    testWidgets(
      'multiple cards can be expanded simultaneously',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        final widget = Center(
          child: SizedBox(
            width: 1100,
            child: CampaignTimeline(
              timelineItems: timelineItems,
            ),
          ),
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Description 1'), findsNothing);
        expect(find.text('Test Description 2'), findsNothing);

        // Expand first card
        await tester.tap(find.byType(CampaignTimelineCard).first);
        await tester.pumpAndSettle();

        // Verify first card expanded
        expect(find.text('Test Description 1'), findsOneWidget);
        expect(find.text('Test Description 2'), findsNothing);

        // Expand second card
        await tester.tap(find.byType(CampaignTimelineCard).at(1));
        await tester.pumpAndSettle();

        // Verify both cards are expanded
        expect(find.text('Test Description 1'), findsOneWidget);
        expect(find.text('Test Description 2'), findsOneWidget);
      },
    );
  });
}
