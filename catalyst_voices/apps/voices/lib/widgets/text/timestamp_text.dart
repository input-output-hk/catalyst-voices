import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TimestampText extends StatelessWidget {
  final DateTime data;
  final bool showTimezone;
  final bool includeTime;
  final TextStyle? style;

  const TimestampText(
    this.data, {
    super.key,
    this.showTimezone = true,
    this.includeTime = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      data,
      showTimezone: showTimezone,
      style: style,
      formatter: (context, dateTime) {
        return DateFormatter.formatTimestamp(dateTime, includeTime: includeTime);
      },
    );
  }
}
