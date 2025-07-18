import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VoteButton extends StatelessWidget {
  final UserVoteState data;
  final ValueChanged<VoteType> onSelected;
  final VoidCallback? onRemove;

  const VoteButton({
    super.key,
    this.data = const UserVoteState(),
    required this.onSelected,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = data.colors(context);
    const states = <WidgetState>{};

    final backgroundColor = colors.background.resolve(states);
    final foregroundColor = colors.foreground.resolve(states);

    final textTheme = context.textTheme;
    final textStyle = (textTheme.labelLarge ?? const TextStyle()).copyWith(color: foregroundColor);
    final iconStyle = IconThemeData(size: 18, color: foregroundColor);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: DefaultTextStyle(
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: IconTheme(
          data: iconStyle,
          child: _VoteButtonExpanded(
            data,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}

class _VoteButtonExpanded extends StatelessWidget {
  final UserVoteState data;
  final ValueChanged<VoteType> onSelected;

  const _VoteButtonExpanded(
    this.data, {
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 294, height: 32),
      child: data.hasVoted
          ? _VoteButtonHasVoted(
              voteType: data.draft?.type ?? data.casted?.type,
              votedAt: !data.hasDraftVote ? data.castedVotedAt : null,
              inVoteList: data.hasDraftVote,
              onChanged: onSelected,
            )
          : _VoteButtonNoVote(onSelected: onSelected),
    );
  }
}

class _VoteButtonHasVoted extends StatelessWidget {
  final VoteType? voteType;
  final DateTime? votedAt;
  final bool inVoteList;
  final ValueChanged<VoteType> onChanged;

  const _VoteButtonHasVoted({
    this.voteType,
    this.votedAt,
    this.inVoteList = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final voteType = this.voteType;
    final votedAt = this.votedAt;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        ...<Widget>[
          if (voteType != null) Text(voteType.localisedName(context, present: inVoteList)),
          if (votedAt != null) TimestampText(votedAt, showTimezone: false),
          if (inVoteList) const _VoteInVoteListText(),
        ].separatedBy(const Text('·')),
        VoicesAssets.icons.chevronDown.buildIcon(),
      ],
    );
  }
}

class _VoteButtonNoVote extends StatelessWidget {
  final ValueChanged<VoteType> onSelected;

  const _VoteButtonNoVote({
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _VoteButtonNoVoteYes(onTap: () => onSelected(VoteType.yes))),
        const VoicesVerticalDivider(width: 1),
        Expanded(child: _VoteButtonNoVoteAbstain(onTap: () => onSelected(VoteType.abstain))),
      ],
    );
  }
}

class _VoteButtonNoVoteAbstain extends StatelessWidget {
  final VoidCallback onTap;

  const _VoteButtonNoVoteAbstain({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _VoteButtonNoVoteChoice(
      voteType: VoteType.abstain,
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
    );
  }
}

class _VoteButtonNoVoteChoice extends StatelessWidget {
  final VoteType voteType;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const _VoteButtonNoVoteChoice({
    required this.voteType,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            voteType.icon().buildIcon(),
            Text(voteType.localisedName(context)),
          ],
        ),
      ),
    );
  }
}

class _VoteButtonNoVoteYes extends StatelessWidget {
  final VoidCallback onTap;

  const _VoteButtonNoVoteYes({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _VoteButtonNoVoteChoice(
      voteType: VoteType.yes,
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
    );
  }
}

class _VoteInVoteListText extends StatelessWidget {
  const _VoteInVoteListText();

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.inVoteList);
  }
}
