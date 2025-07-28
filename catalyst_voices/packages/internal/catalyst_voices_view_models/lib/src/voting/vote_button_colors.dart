import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoteButtonBackgroundColor extends WidgetStateProperty<Color> {
  final VoteType? selectedType;
  final bool isVoted;
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  VoteButtonBackgroundColor({
    this.selectedType,
    this.isVoted = false,
    required this.colorScheme,
    required this.colors,
  });

  // primary vs onSurfaceNeutral08
  @override
  Color resolve(Set<WidgetState> states) {
    return switch (selectedType) {
      null => colorScheme.primary,
      VoteType.yes when states.contains(WidgetState.hovered) => colors.votingPositiveHover,
      VoteType.yes when isVoted => colors.votingPositiveVoted,
      VoteType.yes => colors.votingPositivePrimary,
      VoteType.abstain when states.contains(WidgetState.hovered) => colors.votingAbstainHover,
      VoteType.abstain when isVoted => colors.votingAbstainVoted,
      VoteType.abstain => colors.votingAbstainPrimary,
    };
  }
}

class VoteButtonForegroundColor extends WidgetStateProperty<Color> {
  final VoteType type;
  final ColorScheme colorScheme;
  final VoicesColorScheme colors;

  VoteButtonForegroundColor({
    required this.type,
    required this.colorScheme,
    required this.colors,
  });

  // textOnPrimaryWhite vs textOnPrimaryLevel0
  @override
  Color resolve(Set<WidgetState> states) {
    return colors.textOnPrimaryWhite;
  }
}
