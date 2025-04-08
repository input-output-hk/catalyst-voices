import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class LastEditDate extends StatelessWidget {
  final DateTime dateTime;
  final bool showTimezone;
  final TextStyle? textStyle;

  const LastEditDate({
    super.key,
    required this.dateTime,
    required this.showTimezone,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      dateTime,
      formatter: (context, date) {
        final dt = DateFormatter.formatDayMonthTime(
          date,
        );
        return context.l10n.lastEditDate(dt);
      },
      style: textStyle ??
          context.textTheme.labelMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
      showTimezone: showTimezone,
    );
  }
}
