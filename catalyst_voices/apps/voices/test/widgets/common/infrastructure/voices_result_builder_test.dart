import 'dart:async';

import 'package:catalyst_voices/widgets/common/infrastructure/voices_result_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result_type/result_type.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(ResultBuilder, () {
    const minLoadingDuration = Duration(milliseconds: 300);

    testWidgets('shows loading state when result is null',
        (WidgetTester tester) async {
      // Arrange: Provide a loading builder
      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: null,
          successBuilder: (context, data) => Text('Success: $data'),
          failureBuilder: (context, data) => Text('Failure: $data'),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      // Let the application build
      await tester.pump(const Duration(milliseconds: 100));

      // Assert: Verify that the loading widget is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows success state when result is Success',
        (WidgetTester tester) async {
      // Arrange: Provide a success result
      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: Success('Test Success'),
          successBuilder: (context, data) => Text('Success: $data'),
          failureBuilder: (context, data) => Text('Failure: $data'),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      // Let the application build
      await tester.pumpAndSettle();

      // Assert: Verify that the success widget is shown
      expect(find.text('Success: Test Success'), findsOneWidget);
    });

    testWidgets('shows failure state when result is Failure',
        (WidgetTester tester) async {
      // Arrange: Provide a failure result
      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: Failure('Test Failure'),
          successBuilder: (context, data) => Text('Success: $data'),
          failureBuilder: (context, data) => Text('Failure: $data'),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      // Let the application build
      await tester.pumpAndSettle();

      // Assert: Verify that the failure widget is shown
      expect(find.text('Failure: Test Failure'), findsOneWidget);
    });

    testWidgets('shows loading state for the minimum duration',
        (WidgetTester tester) async {
      // Arrange: Provide a delayed success result

      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: null,
          minLoadingDuration: minLoadingDuration,
          successBuilder: (context, data) => Text('Success: $data'),
          failureBuilder: (context, data) => Text('Failure: $data'),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      // Let the application build
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Simulate updating to success result after a delay
      await tester.pump(minLoadingDuration); // Simulate passing of time

      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: Success('Test Success'),
          minLoadingDuration: minLoadingDuration,
          successBuilder: (context, data) => Text('Success: $data'),
          failureBuilder: (context, data) => Text('Failure: $data'),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the success widget is shown after minLoadingDuration
      expect(find.text('Success: Test Success'), findsOneWidget);
    });

    testWidgets('does not update result before minLoadingDuration',
        (WidgetTester tester) async {
      // Arrange: Start with loading and transition to success
      final completer = Completer<Result<String, String>>();

      await tester.pumpApp(
        FutureBuilder(
          future: completer.future,
          builder: (context, snapshot) {
            return ResultBuilder<String, String>(
              result: snapshot.data,
              minLoadingDuration: minLoadingDuration,
              successBuilder: (context, data) => Text('Success: $data'),
              failureBuilder: (context, data) => Text('Failure: $data'),
              loadingBuilder: (context) => const CircularProgressIndicator(),
            );
          },
        ),
      );

      // Let the application build
      await tester.pump(const Duration(milliseconds: 100));

      // Assert that the loading state is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act: Before minLoadingDuration, success should not be displayed yet
      await tester.pump(const Duration(milliseconds: 100)); // Simulate 100ms

      // Assert that it is still showing the loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Success: Test Success'), findsNothing);

      // Simulate success
      completer.complete(Success('Test Success'));

      // Now simulate passing the minLoadingDuration,
      // 100ms remaining at this point
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Verify that after the full duration, success is displayed
      expect(find.text('Success: Test Success'), findsOneWidget);
    });

    testWidgets('handles result updates and switches between states',
        (WidgetTester tester) async {
      // Arrange: Start with a null result (loading state)
      const successWidgetKey = Key('success');
      const failureWidgetKey = Key('failure');

      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) {
            return ResultBuilder<String, String>(
              result: null,
              successBuilder: (context, data) =>
                  Text('Success: $data', key: successWidgetKey),
              failureBuilder: (context, data) =>
                  Text('Failure: $data', key: failureWidgetKey),
              loadingBuilder: (context) => const CircularProgressIndicator(),
            );
          },
        ),
      );

      // Let the application build
      await tester.pump(const Duration(milliseconds: 100));

      // Verify initial loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Act: Update to success state
      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: Success('Test Success'),
          successBuilder: (context, data) =>
              Text('Success: $data', key: successWidgetKey),
          failureBuilder: (context, data) =>
              Text('Failure: $data', key: failureWidgetKey),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify that success state is now shown
      expect(find.byKey(successWidgetKey), findsOneWidget);
      expect(find.text('Success: Test Success'), findsOneWidget);

      // Act: Update to failure state
      await tester.pumpApp(
        ResultBuilder<String, String>(
          result: Failure('Test Failure'),
          successBuilder: (context, data) =>
              Text('Success: $data', key: successWidgetKey),
          failureBuilder: (context, data) =>
              Text('Failure: $data', key: failureWidgetKey),
          loadingBuilder: (context) => const CircularProgressIndicator(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify that failure state is now shown
      expect(find.byKey(failureWidgetKey), findsOneWidget);
      expect(find.text('Failure: Test Failure'), findsOneWidget);
    });
  });
}
