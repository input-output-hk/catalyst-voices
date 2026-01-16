import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

// TODO(damian-molinski): Docs should say this is contest(category) nomination
final class RepresentativeNomination extends Equatable {
  final DocumentRef id;
  final bool isRevoked;
  final DocumentParameters parameters;

  const RepresentativeNomination({
    required this.id,
    this.isRevoked = false,
    this.parameters = const DocumentParameters(),
  });

  @override
  List<Object?> get props => [
    id,
    isRevoked,
    parameters,
  ];

  RepresentativeNomination copyWith({
    DocumentRef? id,
    bool? isRevoked,
    DocumentParameters? parameters,
  }) {
    return RepresentativeNomination(
      id: id ?? this.id,
      isRevoked: isRevoked ?? this.isRevoked,
      parameters: parameters ?? this.parameters,
    );
  }
}
