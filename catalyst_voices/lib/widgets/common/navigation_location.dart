import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A widget that displays a navigation location with breadcrumb style.
///
/// This widget renders a [Container] with the provided `padding` and
/// `constraints`.
///
/// It displays the navigation location as a [RichText] with each part of the
/// location separated by a forward slash (`/`).
/// The first part is rendered in bold text, while subsequent parts use the
/// regular style.
///
/// Consider using this widget for breadcrumbs in your navigation bar or
/// other locations where you want to show a user's current location within
/// the application hierarchy.
// Note. Maybe we can introduce RouterNavigationLocation which depends on
// GoRouter.of(context)
class NavigationLocation extends StatelessWidget {
  /// A list of strings representing the parts of the navigation location.
  final List<String> parts;

  /// The padding to apply to the container. Defaults to a symmetric horizontal
  /// padding of 40.
  final EdgeInsetsGeometry padding;

  /// The constraints applied to the container. Defaults to a tight constraint
  /// with a height of 56.
  final BoxConstraints constraints;

  const NavigationLocation({
    super.key,
    required this.parts,
    this.padding = const EdgeInsets.symmetric(horizontal: 40),
    this.constraints = const BoxConstraints.tightFor(height: 56),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      constraints: constraints,
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colors.textOnPrimary,
          ),
          children: parts
              .mapIndexed(
                (index, part) {
                  return TextSpan(
                    text: part,
                    style: index == 0
                        ? const TextStyle(fontWeight: FontWeight.bold)
                        : null,
                  );
                },
              )
              .separatedBy(const TextSpan(text: ' / '))
              .toList(),
        ),
      ),
    );
  }
}
