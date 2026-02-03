import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

enum VoteTypeFilterOption {
  all,
  yes,
  abstain;

  String localizedName(VoicesLocalizations l10n) => switch (this) {
    VoteTypeFilterOption.all => l10n.allVotesFilter,
    VoteTypeFilterOption.yes => l10n.yesVotesFilter,
    VoteTypeFilterOption.abstain => l10n.abstainVotesFilter,
  };

  /// Converts to [VoteType] if applicable, null for [all].
  VoteType? toVoteType() => switch (this) {
    VoteTypeFilterOption.all => null,
    VoteTypeFilterOption.yes => VoteType.yes,
    VoteTypeFilterOption.abstain => VoteType.abstain,
  };

  /// Creates from [VoteType], null maps to [all].
  static VoteTypeFilterOption fromVoteType(VoteType? voteType) => switch (voteType) {
    null => VoteTypeFilterOption.all,
    VoteType.yes => VoteTypeFilterOption.yes,
    VoteType.abstain => VoteTypeFilterOption.abstain,
  };
}

/// A filter widget for filtering proposals by vote type in the "My Votes" tab.
class VotingVoteTypeFilter extends StatelessWidget {
  final VoteType? voteType;

  const VotingVoteTypeFilter({
    super.key,
    required this.voteType,
  });

  @override
  Widget build(BuildContext context) {
    final selectedOption = VoteTypeFilterOption.fromVoteType(voteType);

    return Wrap(
      spacing: 12,
      children: VoteTypeFilterOption.values.map(
        (option) {
          final isSelected = selectedOption == option;
          return VoicesChip(
            leading: isSelected ? VoicesAssets.icons.check.buildIcon() : null,
            content: Text(option.localizedName(context.l10n)),
            backgroundColor: isSelected ? context.colors.onSurfacePrimaryContainer : null,
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.read<VotingCubit>().changeVoteTypeFilter(option.toVoteType()),
          );
        },
      ).toList(),
    );
  }
}
