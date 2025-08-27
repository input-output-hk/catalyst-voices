import 'package:flutter/material.dart';

/// A wrapper for [TabController] that allows to work with strongly typed [tabs].
final class VoicesTabController<T extends Object> extends TabController {
  final List<T> tabs;

  VoicesTabController({
    T? initialTab,
    super.animationDuration,
    required super.vsync,
    required this.tabs,
  }) : super(
         initialIndex: _getTabIndex(tabs, initialTab) ?? 0,
         length: tabs.length,
       );

  T get tab => tabs[index];

  set tab(T tab) {
    final newIndex = _getTabIndex(tabs, tab);
    if (newIndex == null) {
      throw ArgumentError('$tab is not within allowed $tabs');
    }
    index = newIndex;
  }

  void animateToTab(T tab, {Duration? duration, Curve curve = Curves.ease}) {
    final newIndex = _getTabIndex(tabs, tab);
    if (newIndex == null) {
      throw ArgumentError('$tab is not within allowed $tabs');
    }

    animateTo(newIndex, duration: duration, curve: curve);
  }

  bool containsTab(T tab) {
    return tabs.contains(tab);
  }

  static int? _getTabIndex<T extends Object>(List<T> tabs, T? tab) {
    if (tab == null) return null;

    final index = tabs.indexOf(tab);
    if (index < 0) return null;

    return index;
  }
}
