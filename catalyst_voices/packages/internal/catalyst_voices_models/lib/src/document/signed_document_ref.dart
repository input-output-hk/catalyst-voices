import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SignedDocumentRef extends Equatable {
  final String id;
  final String? version;

  const SignedDocumentRef({
    required this.id,
    this.version,
  });

  bool get isExact => version != null;

  SignedDocumentRef copyWith({
    String? id,
    Optional<String>? version,
  }) {
    return SignedDocumentRef(
      id: id ?? this.id,
      version: version.dataOr(this.version),
    );
  }

  @override
  List<Object?> get props => [id, version];
}

final class SecuredSignedDocumentRef extends Equatable {
  final SignedDocumentRef ref;
  final String hash;

  const SecuredSignedDocumentRef({
    required this.ref,
    required this.hash,
  });

  @override
  List<Object?> get props => [ref, hash];
}
