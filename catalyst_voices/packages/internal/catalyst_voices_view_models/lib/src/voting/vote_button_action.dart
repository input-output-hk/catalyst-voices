import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class VoteButtonAction extends Equatable {
  const VoteButtonAction();
}

final class VoteButtonActionRemoveDraft extends VoteButtonAction {
  const VoteButtonActionRemoveDraft();

  @override
  List<Object?> get props => [];
}

final class VoteButtonActionVote extends VoteButtonAction {
  final VoteType type;

  const VoteButtonActionVote(this.type);

  @override
  List<Object?> get props => [type];
}
