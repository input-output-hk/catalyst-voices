import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DayAtTimeText extends StatelessWidget {
  final DateTime dateTime;
  final bool showTimezone;

  const DayAtTimeText({
    super.key,
    required this.dateTime,
    required this.showTimezone,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      dateTime,
      formatter: (context, dateTime) {
        final date = DateFormatter.formatDateTimeParts(dateTime);
        return context.l10n.dateAtTime(date.date, date.time);
      },
      style: context.textTheme.titleSmall,
      showTimezone: showTimezone,
    );
  }
}
