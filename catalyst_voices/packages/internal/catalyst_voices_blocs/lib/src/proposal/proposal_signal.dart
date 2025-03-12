final class ChangeVersionSignal implements ProposalSignal {
  final String to;

  ChangeVersionSignal({
    required this.to,
  });
}

sealed class ProposalSignal {}

final class ViewingOlderVersionSignal implements ProposalSignal {
  const ViewingOlderVersionSignal();
}
