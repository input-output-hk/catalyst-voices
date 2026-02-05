import 'package:catalyst_voices/widgets/cards/countdown_value_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedVoicesCountdown extends StatelessWidget {
  final DateTime dateTime;
  final ValueChanged<bool>? onCountdownEnd;
  final AnimatedVoicesCountdownThemeData? themeData;

  const AnimatedVoicesCountdown({
    super.key,
    required this.dateTime,
    this.onCountdownEnd,
    this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveThemeData = themeData ?? AnimatedVoicesCountdownThemeData.defaultTheme(context);

    return AnimatedVoicesCountdownTheme(
      data: effectiveThemeData,
      child: VoicesCountdown(
        dateTime: dateTime,
        onCountdownEnd: onCountdownEnd,
        builder:
            (
              context, {
              required ValueListenable<int> days,
              required ValueListenable<int> hours,
              required ValueListenable<int> minutes,
              required ValueListenable<int> seconds,
            }) => Row(
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
    );
  }
}
