import 'package:catalyst_voices/widgets/headers/section_header.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(SectionHeader, () {
    testWidgets(
      'renders correctly with default values',
      (tester) async {
        // Given
        const widget = SectionHeader(title: Text('Title'));

        // When
        await tester.pumpApp(widget);
        await tester.pumpAndSettle();

        // Then
        expect(find.text('Title'), findsOneWidget);
      },
    );

    testWidgets(
      'leading and trailing are rendered',
      (tester) async {
        // Given
        final widget = SectionHeader(
          leading: IconButton(
            key: const ValueKey('BackIconButtonKey'),
            onPressed: () {},
            icon: const Icon(Icons.arrow_left),
          ),
          title: const Text('Title'),
          trailing: [
            IconButton(
              key: const ValueKey('SettingsIconButtonKey'),
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ],
        );

        // When
        await tester.pumpApp(widget);
        await tester.pumpAndSettle();

        // Then
        expect(find.byIcon(Icons.arrow_left), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      },
    );

    testWidgets(
      'DefaultTextStyle is configured correctly',
      (tester) async {
        // Given
        const widget = SectionHeader(title: Text('Title'));
        const voicesColors = VoicesColorScheme.optional(
          textOnPrimary: Colors.deepOrange,
        );

        // When
        await tester.pumpApp(
          widget,
          voicesColors: voicesColors,
        );
        await tester.pumpAndSettle();

        final defaultTextStyleWidget = tester.firstWidget<DefaultTextStyle>(
          find.ancestor(
            of: find.text('Title'),
            matching: find.byType(DefaultTextStyle),
          ),
        );

        // Then
        expect(defaultTextStyleWidget.style.color, Colors.deepOrange);
        expect(defaultTextStyleWidget.maxLines, 1);
        expect(defaultTextStyleWidget.overflow, TextOverflow.ellipsis);
      },
    );
  });
}
