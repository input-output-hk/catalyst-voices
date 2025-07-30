import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoteButtonBackgroundColor extends WidgetStateProperty<Color> {
  final VoteType? voteType;
  final bool isCasted;
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  VoteButtonBackgroundColor({
    this.voteType,
    this.isCasted = false,
    required this.colorScheme,
    required this.colors,
  });

  @override
  Color resolve(Set<WidgetState> states) {
    return switch (voteType) {
      null => colorScheme.primary,
      _ when !states.contains(WidgetState.selected) => colors.onSurfaceNeutral08,
      VoteType.yes when states.contains(WidgetState.hovered) => colors.votingPositiveHover,
      VoteType.yes when isCasted => colors.votingPositiveVoted,
      VoteType.yes => colors.votingPositivePrimary,
      VoteType.abstain when states.contains(WidgetState.hovered) => colors.votingAbstainHover,
      VoteType.abstain when isCasted => colors.votingAbstainVoted,
      VoteType.abstain => colors.votingAbstainPrimary,
    };
  }
}

class VoteButtonForegroundColor extends WidgetStateProperty<Color> {
  final VoteType? voteType;
  final bool isCasted;
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  VoteButtonForegroundColor({
    this.voteType,
    this.isCasted = false,
    required this.colorScheme,
    required this.colors,
  });

  @override
  Color resolve(Set<WidgetState> states) {
    return switch (voteType) {
      _ when voteType != null && !states.contains(WidgetState.selected) =>
        colors.textOnPrimaryLevel0,
      _ => colors.textOnPrimaryWhite,
    };
  }
}
