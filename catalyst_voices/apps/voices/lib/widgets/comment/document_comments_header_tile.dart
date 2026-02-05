import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DocumentCommentsHeaderTile extends StatelessWidget {
  final DocumentCommentsSort sort;
  final ValueChanged<DocumentCommentsSort> onChanged;
  final bool showSort;

  const DocumentCommentsHeaderTile({
    super.key,
    required this.sort,
    required this.onChanged,
    required this.showSort,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _TitleText(),
        const Spacer(),
        Offstage(
          offstage: !showSort,
          child: _SortDropdownButton(
            selected: sort,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SortDropdownButton extends StatelessWidget {
  final DocumentCommentsSort selected;
  final ValueChanged<DocumentCommentsSort> onChanged;

  const _SortDropdownButton({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedPopupMeuButton<DocumentCommentsSort>(
      items: DocumentCommentsSort.values,
      initialValue: selected,
      builder: (context, index) {
        final value = DocumentCommentsSort.values[index];
        return Text(value.localizedName(context));
      },
      onSelected: onChanged,
      leading: selected.icon.buildIcon(),
      child: Text(selected.localizedName(context)),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.commentsSegment,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
