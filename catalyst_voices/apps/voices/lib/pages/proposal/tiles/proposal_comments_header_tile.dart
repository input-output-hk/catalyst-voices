import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalCommentsHeaderTile extends StatelessWidget {
  final ProposalCommentsSort sort;

  const ProposalCommentsHeaderTile({
    super.key,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _TitleText(),
        const Spacer(),
        _SortDropdownButton(selected: sort),
      ],
    );
  }
}

class _SortDropdownButton extends StatelessWidget {
  final ProposalCommentsSort selected;

  const _SortDropdownButton({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.proposalViewCommentsSegment,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
