import 'dart:async';

import 'package:catalyst_voices/widgets/cards/countdown_value_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
            builder: (context, days, hours, minutes, seconds) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CountDownValueCard(
                  value: days,
                  unit: context.l10n.days,
                ),
                CountDownValueCard(
                  value: hours,
                  unit: context.l10n.hours,
                ),
                CountDownValueCard(
                  value: minutes,
                  unit: context.l10n.minutes,
                ),
                CountDownValueCard(
                  value: seconds,
                  unit: context.l10n.seconds,
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
