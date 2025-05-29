import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CategoryDescriptionExpandableList extends StatelessWidget {
  final List<CategoryDescriptionViewModel> descriptions;

  const CategoryDescriptionExpandableList({super.key, required this.descriptions});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32,
      children: descriptions
          .map<Widget>(
            (e) => VoicesExpansionTile(
              title: _Header(e.title),
              initiallyExpanded: true,
              backgroundColor: Colors.transparent,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _BodyText(e.description),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String value;

  const _BodyText(this.value);

  @override
  Widget build(BuildContext context) {
    return MarkdownText(
      MarkdownData(value),
      pStyle: context.textTheme.bodyLarge,
    );
  }
}

class _Header extends StatelessWidget {
  final String value;

  const _Header(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: context.textTheme.titleLarge?.copyWith(color: context.colors.textOnPrimaryLevel1),
    );
  }
}
