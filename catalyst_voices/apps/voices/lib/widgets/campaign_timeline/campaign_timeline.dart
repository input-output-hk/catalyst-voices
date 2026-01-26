import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignTimeline extends StatefulWidget {
  final List<CampaignTimelineViewModel> timelineItems;
  final Widget horizontalPadding;

  const CampaignTimeline({
    super.key,
    required this.timelineItems,
    this.horizontalPadding = const SizedBox.shrink(),
  });

  @override
  State<CampaignTimeline> createState() => CampaignTimelineState();
}

class CampaignTimelineState extends State<CampaignTimeline> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleHorizontalScroll,
      behavior: HitTestBehavior.translucent,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.horizontalPadding,
              ...widget.timelineItems.map((e) => CampaignTimelineCard(timelineItem: e)),
              widget.horizontalPadding,
            ],
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

  void _handleHorizontalScroll(DragUpdateDetails details) {
    _scrollController.jumpTo(
      _scrollController.offset - details.delta.dx,
    );
  }
}
