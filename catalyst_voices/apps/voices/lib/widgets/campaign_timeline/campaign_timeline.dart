import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignTimeline extends StatefulWidget {
  final List<CampaignTimelineViewModel> timelineItem;

  const CampaignTimeline(this.timelineItem, {super.key});

  @override
  State<CampaignTimeline> createState() => CampaignTimelineState();
}

class CampaignTimelineState extends State<CampaignTimeline> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        height: 300,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            _scrollController.jumpTo(
              _scrollController.offset - details.delta.dx,
            );
          },
          // Why not ListView? It forces children to full height
          // (parent constraint).The SingleChildScrollView+Row
          // reserves natural card heights from content.
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.timelineItem.map(CampaignTimelineCard.new),
                ],
              ),
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
}
