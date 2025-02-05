import 'package:equatable/equatable.dart';

final class SignedDocumentRef extends Equatable {
  final String id;
  final String? version;

  const SignedDocumentRef({
    required this.id,
    this.version,
  });

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
