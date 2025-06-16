import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class CampaignStageTimeText extends StatelessWidget {
  final DateRange dateRange;
  const CampaignStageTimeText({super.key, required this.dateRange});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (dateRange.from != null)
          _DateText(
            date: dateRange.from!,
            label: context.l10n.starts,
          ),
        if (dateRange.to != null)
          _DateText(
            date: dateRange.to!,
            label: context.l10n.finishes,
          ),
      ],
    );
  }
}

class _DateText extends StatelessWidget {
  final DateTime date;
  final String label;

  const _DateText({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(color: context.colors.sysColorsNeutralN60),
        ),
        Flexible(
          child: TimezoneDateTimeText(
            date,
            formatter: (context, dateTime) {
              final date = DateFormatter.formatFullDate24Format(dateTime);
              return date;
            },
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}
