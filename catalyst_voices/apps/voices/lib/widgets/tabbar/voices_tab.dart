import 'package:catalyst_voices/widgets/tabbar/voices_tab_bar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A tab to be shown in the [VoicesTabBar].
final class VoicesTab<T extends Object> extends Equatable {
  /// A metadata associated with the tab, usually an enum to distinguish which tab was tapped.
  final T data;

  /// A custom widget key. If not provided a [ValueKey] is created from [data].
  final Key? key;

  // TODO(dt-iohk): remove this flag and replace it with filtering implementation.
  /// Whether the tab should be hidden.
  ///
  /// When the tab is hidden it's still possible to programmatically navigate to it.
  final bool isOffstage;

  /// The child for the tab.
  final Widget child;

  const VoicesTab({
    required this.data,
    this.key,
    this.isOffstage = false,
    required this.child,
  });

  @override
  List<Object?> get props => [data, key, isOffstage, child];
}

/// A default widget to be used as [VoicesTab.child].
class VoicesTabText extends StatelessWidget {
  final String text;

  const VoicesTabText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}

/// A [VoicesTabText] with a leading icon.
class VoicesTabTextWithIcon extends StatelessWidget {
  final Widget icon;
  final String text;

  const VoicesTabTextWithIcon({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        VoicesTabText(text),
      ],
    );
  }
}
