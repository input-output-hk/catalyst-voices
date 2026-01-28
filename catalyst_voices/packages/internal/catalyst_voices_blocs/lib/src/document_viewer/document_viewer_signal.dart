import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:equatable/equatable.dart';

/// Signal emitted by [DocumentViewerCubit]. Tells the UI that the version of the Document has changed.
final class ChangeVersionSignal extends DocumentViewerSignal {
  final String? to;

  const ChangeVersionSignal({
    this.to,
  });

  @override
  List<Object?> get props => [to];
}

sealed class DocumentViewerSignal extends Equatable {
  const DocumentViewerSignal();

  @override
  List<Object?> get props => [];
}

final class UsernameUpdatedSignal extends DocumentViewerSignal {
  const UsernameUpdatedSignal();
}

/// Signal emitted by [DocumentViewerCubit]. Tells the UI that the user is viewing an older version of the Proposal.
final class ViewingOlderVersionSignal extends DocumentViewerSignal {
  const ViewingOlderVersionSignal();
}

final class ViewingOlderVersionWhileVotingSignal extends DocumentViewerSignal {
  const ViewingOlderVersionWhileVotingSignal();
}
