import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text/campaign_stage_time_text.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TimelineCard extends StatelessWidget {
  final List<CampaignTimelineEventWithTitle> timelineItems;

  const TimelineCard({
    super.key,
    required this.timelineItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8,
        runSpacing: 8,
        children: timelineItems
            .map(
              (item) => _TimelineItem(
                dateRange: item.dateRange,
                title: item.localizedEventTitle(context.l10n),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final DateRange dateRange;
  final String title;

  const _TimelineItem({
    required this.dateRange,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall,
        ),
        CampaignStageTimeText(
          dateRange: dateRange,
        ),
      ],
    );
  }
}
