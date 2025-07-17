import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TimestampText extends StatelessWidget {
  final DateTime data;

  const TimestampText(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      data,
      formatter: (context, dateTime) {
        return DateFormatter.formatTimestamp(dateTime);
      },
    );
  }
}
