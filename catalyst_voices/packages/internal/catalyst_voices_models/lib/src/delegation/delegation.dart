import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Delegation is done on campaign level but technically speaking we're delegating
/// per contest(category) of that campaign.
final class Delegation extends Equatable {
  /// The catId of the delegator (account).
  final CatalystId delegatorId;

  /// List of representatives chosen to represent [delegatorId].
  final List<DelegationChoice> choices;

  const Delegation({
    required this.delegatorId,
    this.choices = const [],
  });

  @override
  List<Object?> get props => [
    delegatorId,
    choices,
  ];

  Delegation copyWith({
    CatalystId? delegator,
    List<DelegationChoice>? choices,
  }) {
    return Delegation(
      delegatorId: delegator ?? delegatorId,
      choices: choices ?? this.choices,
    );
  }
}
