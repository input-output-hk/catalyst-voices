import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/separators/voices_vertical_divider.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
    final backgroundColor = data.btnBackgroundColor(context);
    final foregroundColor = data.btnForegroundColor(context);

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
      child: _VoteButtonNoVote(onSelected: onSelected),
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
