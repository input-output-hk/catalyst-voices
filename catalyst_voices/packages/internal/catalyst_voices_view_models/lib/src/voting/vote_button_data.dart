import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class VoteButtonData extends Equatable {
  final VoteTypeDataDraft? draft;
  final VoteTypeDataCasted? casted;

  const VoteButtonData({
    this.draft,
    this.casted,
  });

  factory VoteButtonData.fromVotes({
    Vote? currentDraft,
    Vote? lastCasted,
  }) {
    final draft = currentDraft != null ? VoteTypeDataDraft(type: currentDraft.type) : null;
    final casted = lastCasted != null
        ? VoteTypeDataCasted(
            type: lastCasted.type,
            castedAt: lastCasted.createdAt,
          )
        : null;

    return VoteButtonData(draft: draft, casted: casted);
  }

  DateTime? get castedVotedAt => casted?.castedAt;

  bool get hasDraftVote => draft != null;

  bool get hasVoted => draft != null || casted != null;

  @override
  List<Object?> get props => [draft, casted];

  List<VoteTypeData> get votes => [
        if (draft case final VoteTypeDataDraft draft) draft,
        if (casted case final VoteTypeDataCasted casted) casted,
      ];

  SceneColors colors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.colors;

    final latestVote = votes.firstOrNull;

    final foreground = VoteButtonForegroundColor(
      voteType: latestVote?.type,
      isCasted: latestVote?.isCasted ?? false,
      colorScheme: colorScheme,
      colors: colors,
    );
    final background = VoteButtonBackgroundColor(
      voteType: latestVote?.type,
      isCasted: latestVote?.isCasted ?? false,
      colorScheme: colorScheme,
      colors: colors,
    );

    return (foreground: foreground, background: background);
  }

  VoteButtonData copyWith({
    Optional<VoteTypeDataDraft>? draft,
    Optional<VoteTypeDataCasted>? casted,
  }) {
    return VoteButtonData(
      draft: draft.dataOr(this.draft),
      casted: casted.dataOr(this.casted),
    );
  }
}
