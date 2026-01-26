import 'dart:async';

import 'package:catalyst_voices/widgets/cards/countdown_value_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(VoicesCountdown, () {
    testWidgets('Countdown displays correct time parts', (tester) async {
      final countdownStartCompleter = Completer<void>();
      final futureDate = DateTime.now().add(
        const Duration(
          days: 5,
          hours: 3,
          minutes: 2,
          seconds: 2,
        ),
      );

      await tester.pumpApp(
        SizedBox(
          width: 1000,
          height: 1000,
          child: VoicesCountdown(
            dateTime: futureDate,
            onCountdownStart: (started) {
              if (started) {
                countdownStartCompleter.complete();
              }
            },
            builder: (
              context, {
              required ValueListenable<int> days,
              required ValueListenable<int> hours,
              required ValueListenable<int> minutes,
              required ValueListenable<int> seconds,
            }) =>
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: days,
                  builder: (context, value, _) => CountDownValueCard(
                    value: value,
                    unit: context.l10n.days(value),
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: hours,
                  builder: (context, value, _) => CountDownValueCard(
                    value: value,
                    unit: context.l10n.hours(value),
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: minutes,
                  builder: (context, value, _) => CountDownValueCard(
                    value: value,
                    unit: context.l10n.minutes(value),
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: seconds,
                  builder: (context, value, _) => CountDownValueCard(
                    value: value,
                    unit: context.l10n.seconds(value),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(countdownStartCompleter.future, completes);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
