import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return VoicesOutlinedPopupMeuButton<ProposalCommentsSort>(
      items: ProposalCommentsSort.values,
      initialValue: selected,
      builder: (context, index) {
        final value = ProposalCommentsSort.values[index];
        return Text(value.localizedName(context));
      },
      onSelected: (value) {
        context.read<ProposalCubit>().updateCommentsSort(sort: value);
      },
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
      context.l10n.proposalViewCommentsSegment,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.colors.textOnPrimaryLevel0,
      ),
    );
  }
}
