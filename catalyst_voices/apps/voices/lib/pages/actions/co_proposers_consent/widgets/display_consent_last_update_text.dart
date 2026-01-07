import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text/day_month_time_text.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DisplayConsentLastUpdateText extends StatelessWidget {
  final DateTime? date;
  const DisplayConsentLastUpdateText({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    if (date != null) {
      return DayMonthTimeText(
        dateTime: date!,
        showTimezone: true,
        timestampTextStyle: context.textTheme.labelSmall,
        timezoneTextStyle: context.textTheme.labelSmall,
      );
    }
    return Text(
      context.l10n.notAvailableAbbr.toLowerCase(),
      style: context.textTheme.labelSmall?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
    );
  }
}
