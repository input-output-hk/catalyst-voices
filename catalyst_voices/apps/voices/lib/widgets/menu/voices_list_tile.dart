import 'package:flutter/material.dart';

/// A replacement for the [ListTile] with customized styling.
class VoicesListTile extends StatelessWidget {
  /// The leading widget put in front of the [title].
  final Widget? leading;

  /// The trailing widget put in the back of the [title].
  final Widget? trailing;

  /// The main content of the list tile.
  final Widget? title;

  /// A callback called when the widget is pressed.
  final VoidCallback? onTap;

  /// The default constructor for the [VoicesListTile].
  const VoicesListTile({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;

    return ListTile(
      title: title == null
          ? null
          : DefaultTextStyle(
              style: Theme.of(context).textTheme.labelLarge!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: title,
            ),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
