import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalVersionInfoText extends StatelessWidget {
  final String title;
  final String publish;
  final int iteration;
  final DateTime updateDate;
  final bool boldTitle;
  const ProposalVersionInfoText({
    super.key,
    required this.title,
    required this.publish,
    required this.iteration,
    required this.updateDate,
    required this.boldTitle,
  });

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeTextTheme(
      data: TimezoneDateTimeTextThemeData(
        timestampTextStyle: WidgetStatePropertyAll(
          context.textTheme.labelMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
            fontWeight: boldTitle ? FontWeight.bold : FontWeight.w100,
          ),
        ),
      ),
      child: TimezoneDateTimeText(
        updateDate,
        showTimezone: false,
        formatter: (context, dateTime) {
          final datetime = DateFormatter.formatDayMonthTime(dateTime);

          return context.l10n.proposalIterationPublishUpdateAndTitle(
            iteration,
            publish,
            datetime,
            title,
          );
        },
      ),
    );
  }
}
