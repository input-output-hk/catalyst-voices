import 'package:flutter/material.dart';

class StickyHeader extends StatefulWidget {
  final ScrollNotificationPredicate notificationPredicate;
  final Widget child;

  const StickyHeader({
    super.key,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    required this.child,
  });

  @override
  State<StickyHeader> createState() => _StickyHeaderState();
}

class _StickyHeaderState extends State<StickyHeader> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;
  bool _settled = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _scrolledUnder ? Offset.zero : const Offset(0, -1),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      onEnd: () {
        setState(() {
          _settled = true;
        });
      },
      child: Offstage(
        offstage: _settled && !_scrolledUnder,
        child: widget.child,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = null;

    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && widget.notificationPredicate(notification)) {
      final oldScrolledUnder = _scrolledUnder;
      final metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          _scrolledUnder = metrics.extentAfter > 0;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
        case AxisDirection.right:
        case AxisDirection.left:
          // Scrolled under is only supported in the vertical axis, and should
          // not be altered based on horizontal notifications of the same
          // predicate since it could be a 2D scroller.
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {
          _settled = false;
        });
      }
    }
  }
}
