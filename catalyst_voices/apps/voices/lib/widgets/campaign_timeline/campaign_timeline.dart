import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignTimeline extends StatefulWidget {
  final List<CampaignTimelineViewModel> timelineItems;
  final CampaignTimelinePlacement placement;
  final ValueChanged<bool>? onExpandedChanged;

  const CampaignTimeline({
    super.key,
    required this.timelineItems,
    required this.placement,
    this.onExpandedChanged,
  });

  @override
  State<CampaignTimeline> createState() => CampaignTimelineState();
}

class CampaignTimelineState extends State<CampaignTimeline> {
  final _scrollController = ScrollController();
  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        height: _expandedIndices.isNotEmpty ? 300 : 150,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            _scrollController.jumpTo(
              _scrollController.offset - details.delta.dx,
            );
          },
          // Why not ListView? It forces children to full height
          // (parent constraint).The SingleChildScrollView+Row
          // reserves natural card heights from content.
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.timelineItems.asMap().entries.map(
                      (entry) => CampaignTimelineCard(
                        timelineItem: entry.value,
                        placement: widget.placement,
                        onExpandedChanged: (isExpanded) {
                          _onCardExpanded(isExpanded, entry);
                        },
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _onCardExpanded(
    bool isExpanded,
    MapEntry<int, CampaignTimelineViewModel> entry,
  ) {
    setState(() {
      if (isExpanded) {
        _expandedIndices.add(entry.key);
      } else {
        _expandedIndices.remove(entry.key);
      }
    });
    widget.onExpandedChanged?.call(_expandedIndices.isNotEmpty);
  }
}
