import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class ProposalSubmissionStartText extends StatelessWidget {
  final DateTime startDate;

  const ProposalSubmissionStartText({
    super.key,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeTextTheme(
      data: TimezoneDateTimeTextThemeData(
        timestampTextStyle: WidgetStatePropertyAll<TextStyle>(
          context.textTheme.titleLarge ?? const TextStyle(),
        ),
        foregroundColor:
            WidgetStatePropertyAll(context.colors.textOnPrimaryLevel0),
      ),
      child: TimezoneDateTimeText(
        startDate,
        formatter: (context, dateTime) {
          final date =
              DateFormatter.formatDateTimeParts(dateTime, includeYear: true);

          return context.l10n
              .proposalSubmissionStageStartAt(date.date, date.time);
        },
      ),
    );
  }
}
