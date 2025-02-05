import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignTimelineCard extends StatefulWidget {
  final CampaignTimelineViewModel timelineItem;

  const CampaignTimelineCard(this.timelineItem, {super.key});

  @override
  State<CampaignTimelineCard> createState() => CampaignTimelineCardState();
}

class CampaignTimelineCardState extends State<CampaignTimelineCard> {
  bool isExpanded = false;

  bool get isOngoing => widget.timelineItem.timeline.isTodayInRange();
  SvgGenImage get _expandedIcon => isExpanded
      ? VoicesAssets.icons.chevronDown
      : VoicesAssets.icons.chevronRight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: SizedBox(
        width: 280,
        child: Card(
          shape: OutlineInputBorder(
            borderSide: BorderSide(
              color: isOngoing ? context.colorScheme.primary : Colors.white,
              width: isOngoing ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VoicesAssets.icons.calendar.buildIcon(
                      color: context.colorScheme.primary,
                    ),
                    _expandedIcon.buildIcon(
                      color: context.colorScheme.primaryContainer,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.timelineItem.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colors.textOnPrimaryLevel1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormatter.formatDateRange(
                        MaterialLocalizations.of(context),
                        context.l10n,
                        widget.timelineItem.timeline,
                      ),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.sysColorsNeutralN60,
                      ),
                    ),
                    Offstage(
                      offstage: !isOngoing,
                      child: VoicesChip.round(
                        content: Text(
                          context.l10n.ongoing,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: Durations.medium4,
                  child: isExpanded
                      ? Text(
                          widget.timelineItem.description,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.sysColorsNeutralN60,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
