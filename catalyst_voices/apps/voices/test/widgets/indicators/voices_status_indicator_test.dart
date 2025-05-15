import 'package:catalyst_voices/widgets/indicators/voices_status_indicator.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VoicesStatusIndicator', () {
    testWidgets(
      'VoicesStatusIndicator with Success type builds correctly',
      (tester) async {
        // Arrange
        const status = 'QR VERIFIED';
        const title = 'Your QR code verified successfully';
        const body = 'You can now use your QR-code to login into Catalyst.';

        const colors = VoicesColorScheme.optional(
          success: Colors.green,
          successContainer: Colors.greenAccent,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: const [colors]),
            home: const VoicesStatusIndicator(
              status: Text(status),
              title: Text(title),
              body: Text(body),
              type: VoicesStatusIndicatorType.success,
            ),
          ),
        );

        // Assert
        expect(find.text(status), findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(find.text(body), findsOneWidget);
        final container =
            tester.firstWidget(find.byType(Container)) as Container;
        expect(
          (container.decoration! as BoxDecoration).color,
          equals(colors.success),
        );
      },
    );

    testWidgets(
      'VoicesStatusIndicator with Error type builds correctly',
      (tester) async {
        // Arrange
        const status = 'Error';
        const title = 'An error occurred';
        const body = 'Please try again later.';

        const colors = VoicesColorScheme.optional(
          errorContainer: Colors.redAccent,
        );

        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.transparent,
          error: Colors.red,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: const [colors],
              colorScheme: colorScheme,
            ),
            home: const VoicesStatusIndicator(
              status: Text(status),
              title: Text(title),
              body: Text(body),
              type: VoicesStatusIndicatorType.error,
            ),
          ),
        );

        // Assert
        expect(find.text(status), findsOneWidget);
        expect(find.text(title), findsOneWidget);
        expect(find.text(body), findsOneWidget);
        final container =
            tester.firstWidget(find.byType(Container)) as Container;
        expect(
          (container.decoration! as BoxDecoration).color,
          equals(colorScheme.error),
        );
      },
    );
  });
}
