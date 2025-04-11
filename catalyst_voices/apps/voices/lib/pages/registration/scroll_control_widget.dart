import 'package:catalyst_voices/widgets/scrollbar/voices_scrollbar.dart';
import 'package:flutter/material.dart';

typedef ScrollbarVisibilityBuilder = Widget Function(
  ScrollController controller,
);

class ScrollbarVisibilityWidget extends StatefulWidget {
  final ScrollbarVisibilityBuilder builder;

  const ScrollbarVisibilityWidget({
    super.key,
    required this.builder,
  });

  @override
  State<ScrollbarVisibilityWidget> createState() =>
      _ScrollbarVisibilityWidget();
}

class _ScrollbarVisibilityWidget extends State<ScrollbarVisibilityWidget> {
  late final ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    return VoicesScrollbar(
      alwaysVisible: true,
      padding: const EdgeInsets.only(left: 10),
      child: widget.builder(_controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }
}
