import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/rich_text/markdown_text.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Displays a list of Markdown text with leading icon.
class VoicesList extends StatelessWidget {
  /// The list of items without the bullet.
  final List<String> items;

  /// The icon to display before each item.
  final Widget icon;

  /// The amount of vertical space between the [items].
  final double spacing;

  const VoicesList({super.key, required this.items, required this.icon, this.spacing = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: items.map((e) => _Item(text: e, icon: icon)).toList(),
    );
  }
}

class _Item extends StatelessWidget {
  final String text;
  final Widget icon;

  const _Item({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AffixDecorator(
      prefix: icon,
      crossAxisAlignment: CrossAxisAlignment.start,
      child: MarkdownText(
        MarkdownData(text),
      ),
    );
  }
}
