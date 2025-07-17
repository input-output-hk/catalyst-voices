import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TimestampText extends StatelessWidget {
  final DateTime data;
  final bool showTimezone;

  const TimestampText(
    this.data, {
    super.key,
    this.showTimezone = true,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      data,
      showTimezone: showTimezone,
      formatter: (context, dateTime) {
        return DateFormatter.formatTimestamp(dateTime);
      },
    );
  }
}
