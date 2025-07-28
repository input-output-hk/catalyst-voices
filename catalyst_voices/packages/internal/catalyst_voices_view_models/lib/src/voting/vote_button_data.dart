import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class VoteButtonData extends Equatable {
  final VoteButtonDataDraft? draft;
  final VoteButtonDataCasted? casted;

  const VoteButtonData({
    this.draft,
    this.casted,
  });

  factory VoteButtonData.fromVotes({
    Vote? currentDraft,
    Vote? lastCasted,
  }) {
    final draft = currentDraft != null ? VoteButtonDataDraft(type: currentDraft.type) : null;
    final casted = lastCasted != null
        ? VoteButtonDataCasted(
            type: lastCasted.type,
            createdAt: lastCasted.createdAt,
          )
        : null;

    return VoteButtonData(draft: draft, casted: casted);
  }

  DateTime? get castedVotedAt => casted?.createdAt;

  bool get hasDraftVote => draft != null;

  bool get hasVoted => draft != null || casted != null;

  VoteType? get latestVoteType => draft?.type ?? casted?.type;

  @override
  List<Object?> get props => [draft, casted];

  SceneColors btnColors(BuildContext context) {
    throw UnimplementedError();
  }

  /*UserVoteColors colors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.colors;

    final voteType = latestVoteType;
    final isCasted = draft == null && casted != null;

    final background = UserVoteBackgroundColor(
      voteType: voteType,
      isCasted: isCasted,
      colorScheme: colorScheme,
      colors: colors,
    );
    final foreground = UserVoteForegroundColor(
      voteType: voteType,
      isCasted: isCasted,
      colorScheme: colorScheme,
      colors: colors,
    );

    return (background: background, foreground: foreground);
  }*/

  VoteButtonData copyWith({
    Optional<VoteButtonDataDraft>? draft,
    Optional<VoteButtonDataCasted>? casted,
  }) {
    return VoteButtonData(
      draft: draft.dataOr(this.draft),
      casted: casted.dataOr(this.casted),
    );
  }

  SceneColors menuBtnColors(BuildContext context) {
    throw UnimplementedError();
  }
}

final class VoteButtonDataCasted extends Equatable {
  final VoteType type;
  final DateTime createdAt;

  const VoteButtonDataCasted({
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        type,
        createdAt,
      ];
}

final class VoteButtonDataDraft extends Equatable {
  final VoteType type;

  const VoteButtonDataDraft({
    required this.type,
  });

  @override
  List<Object?> get props => [
        type,
      ];

  VoteButtonDataDraft copyWith({
    VoteType? type,
  }) {
    return VoteButtonDataDraft(
      type: type ?? this.type,
    );
  }
}
