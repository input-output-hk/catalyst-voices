import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class UserVoteState extends Equatable {
  final UserVoteStateDraft? draft;
  final UserVoteStateCasted? casted;

  const UserVoteState({
    this.draft,
    this.casted,
  });

  factory UserVoteState.fromVotes({
    Vote? currentDraft,
    Vote? lastCasted,
  }) {
    final draft = currentDraft != null ? UserVoteStateDraft(type: currentDraft.type) : null;
    final casted = lastCasted != null
        ? UserVoteStateCasted(
            type: lastCasted.type,
            createdAt: lastCasted.createdAt,
          )
        : null;

    return UserVoteState(draft: draft, casted: casted);
  }

  @override
  List<Object?> get props => [draft, casted];

  Color btnBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  Color btnForegroundColor(BuildContext context) {
    return Theme.of(context).colors.textOnPrimaryWhite;
  }

  UserVoteState copyWith({
    Optional<UserVoteStateDraft>? draft,
    Optional<UserVoteStateCasted>? casted,
  }) {
    return UserVoteState(
      draft: draft.dataOr(this.draft),
      casted: casted.dataOr(this.casted),
    );
  }
}

final class UserVoteStateCasted extends Equatable {
  final VoteType type;
  final DateTime createdAt;

  const UserVoteStateCasted({
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        type,
        createdAt,
      ];
}

final class UserVoteStateDraft extends Equatable {
  final VoteType type;

  const UserVoteStateDraft({
    required this.type,
  });

  @override
  List<Object?> get props => [
        type,
      ];

  UserVoteStateDraft copyWith({
    VoteType? type,
  }) {
    return UserVoteStateDraft(
      type: type ?? this.type,
    );
  }
}
