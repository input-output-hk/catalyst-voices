import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignTimelineCard extends StatefulWidget {
  final CampaignTimelineViewModel timelineItem;
  final CampaignTimelinePlacement placement;

  const CampaignTimelineCard({
    super.key,
    required this.timelineItem,
    required this.placement,
  });

  @override
  State<CampaignTimelineCard> createState() => CampaignTimelineCardState();
}

class CampaignTimelineCardState extends State<CampaignTimelineCard> {
  bool _isExpanded = false;

  SvgGenImage get _expandedIcon => _isExpanded
      ? VoicesAssets.icons.chevronDown
      : VoicesAssets.icons.chevronRight;
  bool get _isOngoing => widget.timelineItem.timeline.isTodayInRange();

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        constraints: const BoxConstraints(minHeight: 150),
        width: 288,
        child: Card(
          key: const Key('TimelineCard'),
          color:
              widget.placement.backgroundColor(context, isOngoing: _isOngoing),
          shape: OutlineInputBorder(
            borderSide: widget.placement.borderSide(
              context,
              isOngoing: _isOngoing,
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
                      color: colors.primary,
                    ),
                    _expandedIcon.buildIcon(
                      color: colors.primaryContainer,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        key: const Key('TimelineCardDate'),
                        DateFormatter.formatDateRange(
                          MaterialLocalizations.of(context),
                          context.l10n,
                          widget.timelineItem.timeline,
                        ),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.sysColorsNeutralN60,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isOngoing) ...[
                      const SizedBox(width: 8),
                      Offstage(
                        offstage: !_isOngoing,
                        child: VoicesChip.round(
                          backgroundColor: colors.primary,
                          content: Text(
                            context.l10n.ongoing,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: Durations.medium4,
                  child: _isExpanded
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
      _isExpanded = !_isExpanded;
    });
  }
}

enum CampaignTimelinePlacement {
  discovery,
  workspace;

  Color backgroundColor(
    BuildContext context, {
    required bool isOngoing,
  }) {
    final colors = Theme.of(context).colors;

    return switch ((this, isOngoing)) {
      (discovery, _) => colors.onSurfaceNeutralOpaqueLv0,
      (workspace, true) => colors.onSurfaceNeutralOpaqueLv0,
      (workspace, false) => colors.onSurfaceNeutralOpaqueLv1,
    };
  }

  BorderSide borderSide(
    BuildContext context, {
    required bool isOngoing,
  }) {
    final colorScheme = context.colorScheme;

    return switch ((this, isOngoing)) {
      (discovery, true) => BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      (_, _) => BorderSide.none,
    };
  }
}
