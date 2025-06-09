import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text/campaign_stage_time_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignTimelineCard extends StatefulWidget {
  final CampaignTimelineViewModel timelineItem;

  const CampaignTimelineCard({
    super.key,
    required this.timelineItem,
  });

  @override
  State<CampaignTimelineCard> createState() => CampaignTimelineCardState();
}

class CampaignTimelineCardState extends State<CampaignTimelineCard> {
  bool _isExpanded = false;

  SvgGenImage get _expandedIcon =>
      _isExpanded ? VoicesAssets.icons.chevronDown : VoicesAssets.icons.chevronRight;
  bool get _isOngoing => widget.timelineItem.timeline.isTodayInRange();

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return GestureDetector(
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 153),
        width: 288,
        child: Card(
          key: const Key('TimelineCard'),
          color: context.colors.elevationsOnSurfaceNeutralLv1White,
          shape: OutlineInputBorder(
            borderSide: _getBorder(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    VoicesAssets.icons.calendar.buildIcon(
                      color: colors.primary,
                    ),
                    const SizedBox(width: 12),
                    Offstage(
                      offstage: !_isOngoing,
                      child: VoicesChip.round(
                        backgroundColor: colors.primary,
                        content: Text(
                          context.l10n.ongoing,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _expandedIcon.buildIcon(
                      color: colors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  key: const Key('TimelineCardTitle'),
                  widget.timelineItem.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colors.textOnPrimaryLevel1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                CampaignStageTimeText(dateRange: widget.timelineItem.timeline),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      widget.timelineItem.description,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.textOnPrimaryLevel1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BorderSide _getBorder(BuildContext context) {
    return switch (_isOngoing) {
      true => BorderSide(
          color: context.colorScheme.primary,
          width: 2,
        ),
      false => BorderSide.none,
    };
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
