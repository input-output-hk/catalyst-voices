import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalBuilderMenuItem extends StatelessWidget {
  final ProposalMenuItemAction item;

  const ProposalBuilderMenuItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        ProposalBuilderMenuItemData>(
      selector: (state) => state.buildMenuItem(action: item),
      builder: (context, state) {
        return _ProposalBuilderMenuItem(
          key: ValueKey('Action${state.action}MenuTile'),
          data: state,
        );
      },
    );
  }
}

class _ProposalBuilderMenuItem extends StatelessWidget {
  final ProposalBuilderMenuItemData data;

  const _ProposalBuilderMenuItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = data.title(context);
    final description = data.description(context);
    final colors = data.colors(context);

    final foregroundColor =
        colors?.foreground ?? Theme.of(context).colors.textOnPrimaryLevel1;

    return ListTile(
      title: MarkdownText(
        MarkdownData(title),
        selectable: false,
        pColor: foregroundColor,
      ),
      subtitle: description == null
          ? null
          : Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: foregroundColor),
            ),
      leading: data.action.icon().buildIcon(color: foregroundColor),
      mouseCursor: data.action.clickable ? SystemMouseCursors.click : null,
      // Shape is here so ListTile does not add rounded corners.
      shape: const RoundedRectangleBorder(),
      tileColor: colors?.background,
      splashColor: colors?.foreground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
