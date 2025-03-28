import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VotingStartAtTimeText extends StatelessWidget {
  final DateTime data;
  const VotingStartAtTimeText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      data,
      formatter: (context, dateTime) {
        final date = DateFormatter.formatFullDateTime(dateTime);
        return context.l10n.votingForF14StartsIn(
          date,
        );
      },
    );
  }
}
