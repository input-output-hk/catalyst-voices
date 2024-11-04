import 'package:catalyst_voices/widgets/tooltips/voices_plain_tooltip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('VoicesPlainTooltip', () {
    testWidgets('displays the correct message', (tester) async {
      // Given
      const message = 'This is a tooltip message.';
      const child = Icon(Icons.info);

      const widget = VoicesPlainTooltip(
        message: message,
        child: child,
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
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('is not displayed without hover', (tester) async {
      // Given
      const message = 'This is a tooltip message.';
      const child = Icon(Icons.info);

      const widget = VoicesPlainTooltip(
        message: message,
        child: child,
      );

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      // Then
      expect(find.text(message), findsNothing);
    });

    testWidgets('constrains the text width', (tester) async {
      // Given
      const message = 'This is a very long tooltip message.';
      const child = Icon(Icons.info);

      const widget = VoicesPlainTooltip(
        message: message,
        child: child,
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
      final size = tester.getSize(
        find.byKey(const ValueKey('VoicesPlainTooltipContentKey')),
      );

      expect(size.width, 200.0);
    });
  });
}
