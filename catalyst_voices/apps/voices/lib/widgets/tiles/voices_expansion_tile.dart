import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const VoicesExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
    this.initiallyExpanded = false,
  });

  @override
  State<VoicesExpansionTile> createState() => _VoicesExpansionTileState();
}

class _VoicesExpansionTileState extends State<VoicesExpansionTile> {
  final _controller = ExpansionTileController();

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeOverride(
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);

          return ExpansionTile(
            title: DefaultTextStyle(
              style: theme.textTheme.titleLarge ?? const TextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: widget.title,
            ),
            trailing: ChevronExpandButton(
              isExpanded: _isExpanded,
              onTap: _toggleExpand,
            ),
            controller: _controller,
            initiallyExpanded: _isExpanded,
            onExpansionChanged: _updateExpended,
            children: widget.children,
          );
        },
      ),
    );
  }

  void _updateExpended(bool value) {
    setState(() {
      _isExpanded = value;
    });
  }

  void _toggleExpand() {
    if (_controller.isExpanded) {
      _controller.collapse();
    } else {
      _controller.expand();
    }
  }
}

class _ThemeOverride extends StatelessWidget {
  final Widget child;

  const _ThemeOverride({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        // listTileTheme is required here because ExpansionTile does not let
        // us set shape or ripple used internally by ListTile.
        listTileTheme: const ListTileThemeData(shape: RoundedRectangleBorder()),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: theme.colors.elevationsOnSurfaceNeutralLv0,
          collapsedBackgroundColor: theme.colors.elevationsOnSurfaceNeutralLv0,
          tilePadding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
          childrenPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          textColor: theme.colors.textOnPrimaryLevel1,
          collapsedTextColor: theme.colors.textOnPrimaryLevel1,
          iconColor: theme.colors.iconsForeground,
          collapsedIconColor: theme.colors.iconsForeground,
          shape: const RoundedRectangleBorder(),
          collapsedShape: const RoundedRectangleBorder(),
        ),
      ),
      child: child,
    );
  }
}
