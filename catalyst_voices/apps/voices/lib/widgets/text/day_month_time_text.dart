import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices/widgets/tooltips/voices_plain_tooltip.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class DayMonthTimeText extends StatelessWidget {
  final DateTime dateTime;
  final bool showTimezone;
  final Color? color;

  const DayMonthTimeText({
    super.key,
    required this.dateTime,
    this.showTimezone = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      dateTime,
      formatter: (context, datetime) {
        return DateFormatter.formatDayMonthTime(datetime);
      },
      style: context.textTheme.labelLarge?.copyWith(
        color: color ?? context.colors.textOnPrimaryLevel1,
      ),
      showTimezone: showTimezone,
    );
  }
}

class DayMonthTimeTextWithTooltip extends StatelessWidget {
  final DateTime datetime;
  final bool showTimezone;
  final Color? color;
  const DayMonthTimeTextWithTooltip({
    super.key,
    required this.datetime,
    this.showTimezone = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPlainTooltip(
      message: _tooltipMessage(context),
      child: DayMonthTimeText(
        dateTime: datetime,
        showTimezone: showTimezone,
        color: color,
      ),
    );
  }

  String _tooltipMessage(BuildContext context) {
    final dt = DateFormatter.formatDateTimeParts(datetime, includeYear: true);

    return context.l10n.publishedOn(dt.date, dt.time);
  }
}
