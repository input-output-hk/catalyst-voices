import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ContestDelegation extends Equatable {
  final DocumentRef id;
  final bool isRevoked;
  final DocumentParameters parameters;
  final List<ContestDelegationChoice> choices;

  const ContestDelegation({
    required this.id,
    this.isRevoked = false,
    this.parameters = const DocumentParameters(),
    this.choices = const [],
  });

  bool get hasOutdatedNominations => choices.any((e) => !e.isNominationLatest);

  /// Delegation is valid when not revoked and at least one choice is valid.
  bool get isValid => !isRevoked && choices.isNotEmpty && choices.any((e) => e.isValid);

  @override
  List<Object?> get props => [
    id,
    isRevoked,
    parameters,
    choices,
  ];

  ContestDelegation copyWith({
    DocumentRef? id,
    bool? isRevoked,
    DocumentParameters? parameters,
    List<ContestDelegationChoice>? choices,
  }) {
    return ContestDelegation(
      id: id ?? this.id,
      isRevoked: isRevoked ?? this.isRevoked,
      parameters: parameters ?? this.parameters,
      choices: choices ?? this.choices,
    );
  }
}
