import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// This widget is very similar to [TabBarView], and is meant to be used
/// together with [TabBar], but displays children in non scrollable fashion
/// thanks to [IndexedStack].
class TabBarStackView extends StatefulWidget {
  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of
  /// [DefaultTabController.of] will be used.
  final TabController? controller;

  /// One widget per tab.
  ///
  /// Its length must match the length of the [TabBar.tabs]
  /// list, as well as the [controller]'s [TabController.length].
  final List<Widget> children;

  const TabBarStackView({
    super.key,
    this.controller,
    required this.children,
  });

  @override
  State<TabBarStackView> createState() => _TabBarStackViewState();
}

class _TabBarStackViewState extends State<TabBarStackView> {
  TabController? _controller;

  int? _currentIndex;

  // If the TabBarView is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = _controller!.index;
  }

  @override
  void didUpdateWidget(TabBarStackView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _currentIndex = _controller!.index;
    }
  }

  @override
  void dispose() {
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
    }
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TabsBodyContainer(
      currentIndex: _currentIndex,
      children: widget.children,
    );
  }

  void _updateTabController() {
    final oldController = _controller;
    final newController =
        widget.controller ?? DefaultTabController.maybeOf(context);

    assert(
      newController != null,
      'No TabController for ${widget.runtimeType}.\n'
      'When creating a ${widget.runtimeType}, you must either provide an '
      'explicit '
      'TabController using the "controller" property, or you must ensure that '
      'there '
      'is a DefaultTabController above the ${widget.runtimeType}.\n'
      'In this case, there was neither an explicit controller nor a default '
      'controller.',
    );

    if (newController == oldController) {
      return;
    }

    if (_controllerIsValid) {
      oldController!.animation!
          .removeListener(_handleTabControllerAnimationTick);
    }

    _controller = newController;

    if (newController != null) {
      newController.animation!.addListener(_handleTabControllerAnimationTick);
    }
  }

  void _handleTabControllerAnimationTick() {
    if (!_controller!.indexIsChanging) {
      return;
    }

    if (_controller!.index != _currentIndex) {
      setState(() {
        _currentIndex = _controller!.index;
      });
    }
  }
}

class _TabsBodyContainer extends StatelessWidget {
  final int? currentIndex;
  final List<Widget> children;

  const _TabsBodyContainer({
    this.currentIndex,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: children.mapIndexed(
        (index, child) {
          final isCurrent = index == currentIndex;

          return Offstage(
            offstage: !isCurrent,
            child: TickerMode(
              enabled: isCurrent,
              child: child,
            ),
          );
        },
      ).toList(),
    );
  }
}
