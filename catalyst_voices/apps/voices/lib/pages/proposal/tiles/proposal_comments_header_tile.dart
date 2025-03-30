import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalCommentsHeaderTile extends StatelessWidget {
  final CommentsSort sort;
  final ValueChanged<CommentsSort> onChanged;
  final bool showSort;

  const ProposalCommentsHeaderTile({
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
  final CommentsSort selected;
  final ValueChanged<CommentsSort> onChanged;

  const _SortDropdownButton({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedPopupMeuButton<CommentsSort>(
      items: CommentsSort.values,
      initialValue: selected,
      builder: (context, index) {
        final value = CommentsSort.values[index];
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
