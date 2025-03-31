import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

class ProposalSubmissionClosesText extends StatelessWidget {
  final DateTime dateTime;

  const ProposalSubmissionClosesText({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeTextTheme(
      data: TimezoneDateTimeTextThemeData(
        timestampTextStyle: WidgetStatePropertyAll<TextStyle>(
          context.textTheme.titleLarge ?? const TextStyle(),
        ),
        foregroundColor:
            WidgetStatePropertyAll(context.colors.textOnPrimaryLevel1),
      ),
      child: TimezoneDateTimeText(
        dateTime,
        showTimezone: false,
        formatter: (context, dateTime) {
          final date = DateFormatter.formatFullDateTime(dateTime);

          return context.l10n.proposalSubmittionWindowClosesAt(date);
        },
      ),
    );
  }
}
