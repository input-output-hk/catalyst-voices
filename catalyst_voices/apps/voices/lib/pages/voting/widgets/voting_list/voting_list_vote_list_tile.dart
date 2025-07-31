import 'dart:math';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VotingListVoteListTile extends StatefulWidget {
  const VotingListVoteListTile({super.key});

  @override
  State<VotingListVoteListTile> createState() => _VotingListVoteListTileState();
}

class _VotingListVoteListTileState extends State<VotingListVoteListTile> {
  @override
  Widget build(BuildContext context) {
    return VoicesExpansionTile(
      title: _VotingListVoteListTileTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tilePadding: const EdgeInsets.all(16),
      childrenPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      backgroundColor: context.colors.elevationsOnSurfaceNeutralLv1Grey,
      initiallyExpanded: true,
      children: [
        _VotingListVoteListTileVote(0),
        _VotingListVoteListTileVote(1),
        _VotingListVoteListTileVote(2),
      ],
    );
  }
}

class _VotingListVoteListTileTitle extends StatelessWidget {
  const _VotingListVoteListTileTitle();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        AffixDecorator(
          gap: 4,
          prefix: VoicesAssets.icons.viewGrid.buildIcon(
            size: 18,
            color: colors.iconsForeground,
          ),
          child: Text(
            'Cardano Use Cases: Concept',
            style: textTheme.titleSmall?.copyWith(color: colors.textOnPrimaryLevel0),
          ),
        ),
        Text(
          '3 Votes',
          style: textTheme.bodySmall?.copyWith(color: colors.textOnPrimaryLevel1),
        ),
      ],
    );
  }
}

class _VotingListVoteListTileVote extends StatelessWidget {
  final int index;

  const _VotingListVoteListTileVote(this.index);

  @override
  Widget build(BuildContext context) {
    final keys = Colors.orange.keys;
    final key = keys.elementAt(Random(index).nextInt(keys.length));

    return Container(
      height: 52,
      color: Colors.orange[key],
    );
  }
}
