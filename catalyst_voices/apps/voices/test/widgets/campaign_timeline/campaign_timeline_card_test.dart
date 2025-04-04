import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_brands/src/themes/catalyst.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(CampaignTimelineCard, () {
    final timeline = DateRange(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(days: 7)),
    );

    final timelineItem = CampaignTimelineViewModel(
      title: 'Test Title',
      description: 'Test Description',
      timeline: timeline,
      stage: CampaignTimelineStage.proposalSubmission,
    );

    testWidgets(
      'renders correctly with default values in discovery placement',
      (tester) async {
        final widget = CampaignTimelineCard(
          timelineItem: timelineItem,
          placement: CampaignTimelinePlacement.discovery,
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Title'), findsOneWidget);
        expect(find.text('Test Description'), findsNothing);
      },
    );

    testWidgets(
      'renders correctly with default values in workspace placement',
      (tester) async {
        final widget = CampaignTimelineCard(
          timelineItem: timelineItem,
          placement: CampaignTimelinePlacement.workspace,
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Title'), findsOneWidget);
        expect(find.text('Test Description'), findsNothing);
      },
    );

    testWidgets(
      'shows description when expanded',
      (tester) async {
        final widget = CampaignTimelineCard(
          timelineItem: timelineItem,
          placement: CampaignTimelinePlacement.discovery,
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final gestureDetector = find
            .descendant(
              of: find.byType(CampaignTimelineCard),
              matching: find.byType(GestureDetector),
            )
            .first;

        await tester.tap(gestureDetector);
        await tester.pumpAndSettle();

        expect(find.text('Test Description'), findsOneWidget);
      },
    );

    testWidgets(
      'calls onExpandedChanged when tapped',
      (tester) async {
        var expanded = false;
        final widget = CampaignTimelineCard(
          timelineItem: timelineItem,
          placement: CampaignTimelinePlacement.discovery,
          onExpandedChanged: (isExpanded) => expanded = isExpanded,
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final gestureDetector = find
            .descendant(
              of: find.byType(CampaignTimelineCard),
              matching: find.byType(GestureDetector),
            )
            .first;

        await tester.tap(gestureDetector);
        await tester.pumpAndSettle();

        expect(expanded, isTrue);
      },
    );

    testWidgets(
      'shows ongoing chip for current timeline',
      (tester) async {
        final currentTimelineItem = CampaignTimelineViewModel(
          title: 'Current',
          description: 'Current Description',
          timeline: DateRange(
            from: DateTime.now().subtract(const Duration(days: 1)),
            to: DateTime.now().add(const Duration(days: 1)),
          ),
          stage: CampaignTimelineStage.proposalSubmission,
        );

        final widget = CampaignTimelineCard(
          timelineItem: currentTimelineItem,
          placement: CampaignTimelinePlacement.discovery,
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final voicesChips =
            tester.widgetList<VoicesChip>(find.byType(VoicesChip));
        expect(voicesChips, hasLength(1));

        final ongoingTextWidget = find.text('Ongoing');
        expect(ongoingTextWidget, findsOneWidget);

        final ongoingText = tester.widget<Text>(ongoingTextWidget);
        expect(ongoingText.style?.color, Colors.white);

        final offstage = find
            .ancestor(
              of: ongoingTextWidget,
              matching: find.byType(Offstage),
              matchRoot: true,
            )
            .evaluate()
            .first
            .widget as Offstage;

        expect(offstage.offstage, isFalse);
      },
    );

    testWidgets(
      'applies correct background color based on placement and ongoing status',
      (tester) async {
        final widget = CampaignTimelineCard(
          timelineItem: timelineItem,
          placement: CampaignTimelinePlacement.discovery,
        );

        await tester.pumpApp(
          widget,
          voicesColors: lightVoicesColorScheme,
        );
        await tester.pumpAndSettle();

        final card = find.descendant(
          of: find.byType(CampaignTimelineCard),
          matching: find.byType(Card),
        );
        expect(
          tester.widget<Card>(card).color,
          Colors.white,
        );
      },
    );
  });
}
