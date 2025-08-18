import 'package:catalyst_voices/widgets/cards/countdown_value_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class AnimatedVoicesCountdown extends StatelessWidget {
  final DateTime dateTime;
  final ValueChanged<bool>? onCountdownEnd;

  const AnimatedVoicesCountdown({super.key, required this.dateTime, this.onCountdownEnd});

  @override
  Widget build(BuildContext context) {
    return VoicesCountdown(
      dateTime: dateTime,
      onCountdownEnd: onCountdownEnd,
      builder:
          (
            context, {
            required days,
            required hours,
            required minutes,
            required seconds,
          }) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CountDownValueCard(
                value: days,
                unit: context.l10n.days(days),
              ),
              CountDownValueCard(
                value: hours,
                unit: context.l10n.hours(hours),
              ),
              CountDownValueCard(
                value: minutes,
                unit: context.l10n.minutes(minutes),
              ),
              CountDownValueCard(
                value: seconds,
                unit: context.l10n.seconds(seconds),
              ),
            ],
          ),
    );
  }
}
