import 'package:catalyst_voices/widgets/common/infrastructure/voices_future_builder.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(VoicesFutureBuilder, () {
    testWidgets('Displays data when future completes successfully',
        (tester) async {
      await tester.pumpApp(
        VoicesFutureBuilder<String>(
          future: () async => 'Test Data',
          dataBuilder: (_, __, ___) => const Text('Success'),
        ),
      );

      // Let the future start
      await tester.pump(const Duration(milliseconds: 100));

      // Shows loading indicator while waiting for data
      expect(find.byType(VoicesCircularProgressIndicator), findsOneWidget);

      // Let the future finish
      await tester.pump(const Duration(seconds: 1));

      // Shows success state
      expect(find.text('Success'), findsOneWidget);
    });

    testWidgets('Displays error when future completes with an error',
        (tester) async {
      // Act
      await tester.pumpApp(
        VoicesFutureBuilder<String>(
          future: () async => throw Exception('Error'),
          dataBuilder: (_, __, ___) => const SizedBox.shrink(),
          errorBuilder: (_, __, ___) => const Text('Error Occurred'),
        ),
      );

      // Let the future start
      await tester.pump(const Duration(milliseconds: 100));

      // Shows loading indicator while waiting for data
      expect(find.byType(VoicesCircularProgressIndicator), findsOneWidget);

      // Let the future finish
      await tester.pump(const Duration(seconds: 1));

      // Shows error state
      expect(find.text('Error Occurred'), findsOneWidget);
    });
  });
}
