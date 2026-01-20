import 'package:catalyst_voices_blocs/src/proposal/proposal.dart' show ProposalCubit;
import 'package:catalyst_voices_blocs/src/proposal/proposal_cubit.dart' show ProposalCubit;
import 'package:equatable/equatable.dart';

/// Signal emitted by [ProposalCubit]. Tells the UI that the version of the Proposal has changed.
final class ChangeVersionSignal extends ProposalSignal {
  final String? to;

  const ChangeVersionSignal({
    this.to,
  });

  @override
  List<Object?> get props => [to];
}

/// Base class for signals emitted by [ProposalCubit].
sealed class ProposalSignal extends Equatable {
  const ProposalSignal();

  @override
  List<Object?> get props => [];
}

/// Signal emitted by [ProposalCubit]. Tells the UI that the username has been updated.
final class UsernameUpdatedSignal extends ProposalSignal {
  const UsernameUpdatedSignal();
}

/// Signal emitted by [ProposalCubit]. Tells the UI that the user is viewing an older version of the Proposal.
final class ViewingOlderVersionSignal extends ProposalSignal {
  const ViewingOlderVersionSignal();
}

final class ViewingOlderVersionWhileVotingSignal extends ProposalSignal {
  const ViewingOlderVersionWhileVotingSignal();
}
