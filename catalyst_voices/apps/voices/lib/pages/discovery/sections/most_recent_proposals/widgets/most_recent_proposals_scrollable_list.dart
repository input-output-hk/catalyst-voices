import 'dart:async';

import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals/widgets/most_recent_proposals_list.dart';
import 'package:catalyst_voices/widgets/scrollbar/voices_slider.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MostRecentProposalsScrollableList extends StatefulWidget {
  const MostRecentProposalsScrollableList({super.key});

  @override
  State<MostRecentProposalsScrollableList> createState() {
    return _MostRecentProposalsScrollableListState();
  }
}

class _MostRecentProposalsScrollableListState extends State<MostRecentProposalsScrollableList> {
  late final ScrollController _scrollController;
  final ValueNotifier<double> _scrollPercentageNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesGestureDetector(
          onHorizontalDragUpdate: _onHorizontalDrag,
          child: SizedBox(
            height: 440,
            width: 1200,
            child: Center(child: MostRecentProposalsList(scrollController: _scrollController)),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: ValueListenableBuilder<double>(
            valueListenable: _scrollPercentageNotifier,
            builder: (context, value, child) {
              return VoicesSlider(
                key: const Key('MostRecentProposalsSlider'),
                value: value,
                onChanged: _onSliderChanged,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollPercentageNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    final offset = _scrollController.offset - details.delta.dx;
    final overMax = offset > _scrollController.position.maxScrollExtent;

    if (offset < 0 || overMax) return;

    _scrollController.jumpTo(offset);
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (maxScroll > 0) {
      _scrollPercentageNotifier.value = scrollPosition / maxScroll;
    }
  }

  void _onSliderChanged(double value) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    unawaited(
      _scrollController.animateTo(
        maxScroll * value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      ),
    );
  }
}
