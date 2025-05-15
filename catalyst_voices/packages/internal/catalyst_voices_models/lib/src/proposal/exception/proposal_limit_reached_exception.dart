import 'package:equatable/equatable.dart';

/// An exception thrown attempting to create / import a new
/// proposal when the user has reached the [maxLimit].
final class ProposalLimitReachedException
    with EquatableMixin
    implements Exception {
  final int maxLimit;

  const ProposalLimitReachedException({required this.maxLimit});

  @override
  List<Object?> get props => [maxLimit];

  @override
  String toString() => 'ProposalLimitReachedException(maxLimit=$maxLimit)';
}
