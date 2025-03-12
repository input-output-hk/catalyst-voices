final class ChangeVersionSignal implements ProposalSignal {
  final String? to;

  const ChangeVersionSignal({
    this.to,
  });
}

sealed class ProposalSignal {}

final class ViewingOlderVersionSignal implements ProposalSignal {
  const ViewingOlderVersionSignal();
}
