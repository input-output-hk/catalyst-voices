import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListFooter extends StatelessWidget {
  const VotingListFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingListFooterData>(
      selector: (state) => state.footer,
      builder: (context, state) {
        return _VotingListFooter(data: state);
      },
    );
  }
}

class _CastVotesButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CastVotesButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(context.l10n.votingListCastVotes),
    );
  }
}

class _DisclaimerText extends StatelessWidget {
  const _DisclaimerText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.votingListPendingVotes,
      style: TextStyle(color: context.colorScheme.primary),
    );
  }
}

class _LastVoteStatusText extends StatelessWidget {
  final DateTime? dateTime;

  const _LastVoteStatusText({
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = this.dateTime;

    if (dateTime == null) {
      return Text(
        context.l10n.votingListLastVotedX(context.l10n.votingListNotYetVoted),
        style: TextStyle(color: context.colors.textOnPrimaryLevel1),
      );
    }

    return TimezoneDateTimeText(
      dateTime,
      style: DefaultTextStyle.of(context).style.copyWith(color: context.colors.textOnPrimaryLevel1),
      showTimezone: false,
      formatter: (context, dateTime) {
        final formatted = DateFormatter.formatTimestamp(dateTime, includeTime: false);

        return context.l10n.votingListLastVotedX(formatted);
      },
    );
  }
}

class _VotingListFooter extends StatelessWidget {
  final VotingListFooterData data;

  const _VotingListFooter({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.onSurfaceNeutralOpaqueLv0,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24).subtract(const EdgeInsets.only(top: 8)),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: context.textTheme.bodySmall ?? const TextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (data.showPendingVotesDisclaimer) const _DisclaimerText(),
                  _LastVoteStatusText(dateTime: data.lastCastedVoteAt),
                ],
              ),
            ),
          ),
          Expanded(
            child: _CastVotesButton(
              onTap: data.canCastVotes
                  ? () {
                      context.read<VotingBallotBloc>().add(const ConfirmCastingVotesEvent());
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
