import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalBuilderMenuItem extends StatelessWidget {
  final ProposalBuilderMenuItemData data;

  const ProposalBuilderMenuItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = data.title(context);
    final description = data.description(context);
    final foregroundColor = Theme.of(context).colors.textOnPrimaryLevel1;

    return Stack(
      key: ValueKey('Action${data.action}MenuTile'),
      children: [
        ListTile(
          title: MarkdownText(
            MarkdownData(title),
            selectable: false,
            pColor: foregroundColor,
          ),
          subtitle: description == null
              ? null
              : Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: foregroundColor),
                ),
          leading: data.action.icon().buildIcon(color: foregroundColor),
          mouseCursor: data.action.clickable ? SystemMouseCursors.click : null,
          // Shape is here so ListTile does not add rounded corners.
          shape: const RoundedRectangleBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        if (data.hasError)
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: _ProposalBuilderMenuItemErrorIndicator(),
          ),
      ],
    );
  }
}

class _ProposalBuilderMenuItemErrorIndicator extends StatelessWidget {
  const _ProposalBuilderMenuItemErrorIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      color: Theme.of(context).colorScheme.error,
    );
  }
}
