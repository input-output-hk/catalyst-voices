import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A tab to be shown in the [VoicesTabBar].
final class VoicesTab<T extends Object> extends Equatable {
  /// A metadata associated with the tab, usually an enum to distinguish which tab was tapped.
  final T data;

  /// A custom widget key. If not provided a [ValueKey] is created from [data].
  final Key? key;

  /// Whether the tab should be hidden.
  ///
  /// When the tab is hidden it's still possible to programmatically navigate to it.
  final bool isOffstage;

  /// The text for the tab. Exclusive with [child].
  final String? text;

  /// The child for the tab. Exclusive with [text].
  final Widget? child;

  const VoicesTab.child({
    required this.data,
    this.key,
    this.isOffstage = false,
    required this.child,
  }) : text = null;

  const VoicesTab.text({
    required this.data,
    this.key,
    this.isOffstage = false,
    required this.text,
  }) : child = null;

  @override
  List<Object?> get props => [data, key, isOffstage, text, child];
}
