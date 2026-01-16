import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class Delegation extends Equatable {
  final CatalystId delegatorId;
  final List<ContestDelegation> contestsDelegations;

  const Delegation({
    required this.delegatorId,
    this.contestsDelegations = const [],
  });

  bool get delegatedToOutdatedNomination {
    return contestsDelegations.any((delegation) => delegation.hasOutdatedNominations);
  }

  bool get isValid => contestsDelegations.isNotEmpty && contestsDelegations.every((e) => e.isValid);

  @override
  List<Object?> get props => [
    delegatorId,
    contestsDelegations,
  ];

  Delegation copyWith({
    CatalystId? delegator,
    List<ContestDelegation>? contestsDelegations,
  }) {
    return Delegation(
      delegatorId: delegator ?? this.delegatorId,
      contestsDelegations: contestsDelegations ?? this.contestsDelegations,
    );
  }
}
