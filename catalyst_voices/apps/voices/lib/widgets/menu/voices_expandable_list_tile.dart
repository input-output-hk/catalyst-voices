import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A menu item that can be expanded to show the [expandedChildren].
///
/// Works similarly to a dropdown menu but it doesn't create an overlay
/// with the dropdown, it shows the expanded state by growing the widget
/// height to accommodate for the extra children.
class VoicesExpandableListTile extends StatefulWidget {
  /// The leading widget put in front of the [title].
  final Widget? leading;

  /// The trailing widget put in the back of the [title].
  final Widget? trailing;

  /// The main content of the list tile.
  final Widget? title;

  /// The expanded children that appear in dropdown-like fashion
  /// when the widget is tapped on and expanded.
  final List<Widget> expandedChildren;

  /// The default constructor for the [VoicesExpandableListTile].
  const VoicesExpandableListTile({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    required this.expandedChildren,
  });

  @override
  State<VoicesExpandableListTile> createState() =>
      _VoicesExpandableListTileState();
}

class _VoicesExpandableListTileState extends State<VoicesExpandableListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: _isExpanded
                ? Theme.of(context).colors.onSurfaceSecondary08
                : null,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25),
              topRight: const Radius.circular(25),
              bottomLeft: const Radius.circular(25),
              bottomRight:
                  _isExpanded ? Radius.zero : const Radius.circular(25),
            ),
          ),
          child: VoicesListTile(
            title: widget.title,
            leading: widget.leading,
            trailing: widget.trailing,
            onTap: _onToggle,
          ),
        ),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(left: 60),
            decoration: BoxDecoration(
              color: Theme.of(context).colors.onSurfaceSecondary08,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: widget.expandedChildren,
            ),
          ),
      ],
    );
  }

  void _onToggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
