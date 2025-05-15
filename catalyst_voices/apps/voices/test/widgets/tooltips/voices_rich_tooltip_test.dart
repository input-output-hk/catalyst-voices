import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/tooltips/voices_rich_tooltip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('VoicesRichTooltip', () {
    testWidgets('renders title and message', (tester) async {
      // Given
      const title = 'Tooltip Title';
      const message = 'This is a tooltip message.';

      const widget = VoicesRichTooltip(
        title: title,
        message: message,
        child: Icon(Icons.info),
      );

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(Icon)));
      await tester.pumpAndSettle();

      // Then
      // Find the Text widgets for title and message
      final titleFinder = find.text(title);
      final messageFinder = find.text(message);

      // Expect them to be present in the widget tree
      expect(tester.widget<Text>(titleFinder), isNotNull);
      expect(tester.widget<Text>(messageFinder), isNotNull);
    });
  });

  testWidgets('renders actions', (tester) async {
    // Given
    const title = 'Tooltip Title';
    const message = 'This is a tooltip message.';
    final actions = [
      VoicesRichTooltipActionData(
        name: 'Edit',
        onTap: () => debugPrint('Edit tapped'),
      ),
      VoicesRichTooltipActionData(
        name: 'Delete',
        onTap: () => debugPrint('Delete tapped'),
      ),
    ];

    final widget = VoicesRichTooltip(
      title: title,
      message: message,
      actions: actions,
      child: const Icon(Icons.info),
    );

    // When
    await tester.pumpApp(widget);
    await tester.pumpAndSettle();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.byType(Icon)));
    await tester.pumpAndSettle();

    // Then
    final actionButtons = find
        .byWidgetPredicate((widget) => widget is VoicesTextButton)
        .evaluate();

    expect(actionButtons.length, actions.length);

    // Optionally, verify the text content of each button
    for (var i = 0; i < actions.length; i++) {
      expect(find.text(actions[i].name), findsOne);
    }
  });

  testWidgets('dismisses on tap without actions', (tester) async {
    // Given
    const title = 'Tooltip Title';
    const message = 'This is a tooltip message.';

    final tapped = ValueNotifier(false);

    final widget = Padding(
      padding: const EdgeInsets.all(8),
      child: VoicesRichTooltip(
        title: title,
        message: message,
        child: TextButton(
          onPressed: () => tapped.value = true,
          child: const Text('Trigger'),
        ),
      ),
    );

    // When
    await tester.pumpApp(widget);
    await tester.pumpAndSettle();

    // Tap the trigger button
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.byType(TextButton)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trigger'));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('VoicesRichTooltipContentKey')),
      findsOne,
    );

    // Simulate a tap on the tooltip itself
    await tester.tapAt(tester.getCenter(find.byType(Tooltip)));
    await tester.pump();

    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();

    // Then
    // Expect the Tooltip to be dismissed (no longer rendered)
    expect(
      find.byKey(const ValueKey('VoicesRichTooltipContentKey')),
      findsNothing,
    );

    // Expect the trigger button to be tapped
    expect(tapped.value, true);
  });
}
