import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:flutter/material.dart';

class DayMonthTimeText extends StatelessWidget {
  final DateTime dateTime;
  final bool showTimezone;

  const DayMonthTimeText({
    super.key,
    required this.dateTime,
    this.showTimezone = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      dateTime,
      formatter: (context, lastUpdate) {
        return DateFormatter.formatDayMonthTime(lastUpdate);
      },
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
      showTimezone: showTimezone,
    );
  }
}
