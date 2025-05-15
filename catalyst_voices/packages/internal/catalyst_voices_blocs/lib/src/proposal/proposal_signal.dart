import 'package:equatable/equatable.dart';

final class ChangeVersionSignal extends ProposalSignal {
  final String? to;

  const ChangeVersionSignal({
    this.to,
  });

  @override
  List<Object?> get props => [to];
}

sealed class ProposalSignal extends Equatable {
  const ProposalSignal();

  @override
  List<Object?> get props => [];
}

final class UsernameUpdatedSignal extends ProposalSignal {
  const UsernameUpdatedSignal();
}

final class ViewingOlderVersionSignal extends ProposalSignal {
  const ViewingOlderVersionSignal();
}
