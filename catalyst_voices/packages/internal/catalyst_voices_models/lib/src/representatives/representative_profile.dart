import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeProfile extends Equatable {
  final DocumentRef id;
  final bool isRevoked;
  final DocumentParameters parameters;

  const RepresentativeProfile({
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

  RepresentativeProfile copyWith({
    DocumentRef? id,
    bool? isRevoked,
    DocumentParameters? parameters,
  }) {
    return RepresentativeProfile(
      id: id ?? this.id,
      isRevoked: isRevoked ?? this.isRevoked,
      parameters: parameters ?? this.parameters,
    );
  }
}
