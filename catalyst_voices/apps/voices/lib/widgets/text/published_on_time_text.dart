import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class PublishedOnTimeText extends StatelessWidget {
  final DateTime dateTime;
  final bool showTimezone;
  final Color? color;
  final TextStyle? timestampTextStyle;
  final TextStyle? timezoneTextStyle;

  const PublishedOnTimeText({
    super.key,
    required this.dateTime,
    required this.showTimezone,
    this.color,
    this.timestampTextStyle,
    this.timezoneTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color;

    return TimezoneDateTimeTextTheme(
      data: TimezoneDateTimeTextThemeData(
        foregroundColor: color != null ? WidgetStatePropertyAll(color) : null,
        timestampTextStyle: timestampTextStyle != null
            ? WidgetStatePropertyAll(timestampTextStyle)
            : null,
        timezoneTextStyle: timezoneTextStyle != null
            ? WidgetStatePropertyAll(timezoneTextStyle)
            : null,
      ),
      child: TimezoneDateTimeText(
        dateTime,
        formatter: (context, datetime) {
          final dt = DateFormatter.formatDayMonthTime(datetime);

          return context.l10n.publishedOn(dt);
        },
        showTimezone: showTimezone,
      ),
    );
  }
}
