import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

typedef UserVoteColors = ({
  WidgetStateProperty<Color> background,
  WidgetStateProperty<Color> foreground,
});

class UserVoteBackgroundColor extends WidgetStateProperty<Color> {
  final VoteType? voteType;
  final bool isCasted;
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  UserVoteBackgroundColor({
    required this.voteType,
    required this.isCasted,
    required this.colorScheme,
    required this.colors,
  });

  @override
  Color resolve(Set<WidgetState> states) {
    return switch (voteType) {
      null => colorScheme.primary,
      VoteType.yes when states.contains(WidgetState.hovered) => colors.votingPositiveHover,
      VoteType.yes when isCasted => colors.votingPositiveVoted,
      VoteType.yes => colors.votingPositivePrimary,
      VoteType.abstain when states.contains(WidgetState.hovered) => colors.votingAbstainHover,
      VoteType.abstain when isCasted => colors.votingAbstainVoted,
      VoteType.abstain => colors.votingAbstainPrimary,
    };
  }
}

class UserVoteForegroundColor extends WidgetStateProperty<Color> {
  final VoteType? voteType;
  final bool isCasted;
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  UserVoteForegroundColor({
    required this.voteType,
    required this.isCasted,
    required this.colorScheme,
    required this.colors,
  });

  @override
  Color resolve(Set<WidgetState> states) {
    return colors.textOnPrimaryWhite;
  }
}
