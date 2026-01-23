import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

const _minPixelsDelta = 10.0;

typedef VoicesFloatingActionButtonWidgetBuilder =
    Widget Function(
      BuildContext context,
      //ignore: avoid_positional_boolean_parameters
      bool isExtended,
    );

class VoicesFloatingActionButton extends StatefulWidget {
  final ScrollNotificationPredicate notificationPredicate;
  final bool initialIsExtended;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final VoicesFloatingActionButtonWidgetBuilder builder;

  const VoicesFloatingActionButton({
    super.key,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.initialIsExtended = true,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.onTap,
    required this.builder,
  });

  @override
  State<VoicesFloatingActionButton> createState() => _VoicesFloatingActionButtonState();
}

class _VoicesFloatingActionButtonState extends State<VoicesFloatingActionButton> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _isExtended = false;
  double _prevPixels = 0;

  @override
  Widget build(BuildContext context) {
    final padding = _isExtended
        ? const EdgeInsets.symmetric(vertical: 20, horizontal: 24)
        : EdgeInsets.zero;

    final constraints = _isExtended
        ? const BoxConstraints(maxWidth: 260, maxHeight: 134)
        : BoxConstraints.tight(const Size.square(56));

    final borderRadius = _isExtended ? BorderRadius.circular(28) : BorderRadius.circular(16);

    return AnimatedContainer(
      padding: padding,
      constraints: constraints,
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: [
          BoxShadow(
            offset: const Offset(4, 6),
            blurRadius: 40,
            spreadRadius: -30,
            color: context.colors.dropShadow,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: widget.builder(context, _isExtended),
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

  @override
  void initState() {
    super.initState();
    _isExtended = widget.initialIsExtended;
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && widget.notificationPredicate(notification)) {
      final metrics = notification.metrics;

      final atEdge = metrics.atEdge;
      final pixels = metrics.pixels;
      final pixelsDelta = _prevPixels - pixels;
      _prevPixels = pixels;

      final shouldIgnore = pixelsDelta.abs() <= _minPixelsDelta;
      if (shouldIgnore) return;

      final isExtended = pixelsDelta > 0 || atEdge;
      if (isExtended != _isExtended) {
        setState(() {
          _isExtended = isExtended;
        });
      }
    }
  }
}
