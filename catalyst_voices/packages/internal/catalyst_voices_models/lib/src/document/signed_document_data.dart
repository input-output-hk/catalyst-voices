import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

extension type const SignedDocumentContent(Map<String, dynamic> data)
    implements Object {}

// List of types and metadata fields is here
// https://input-output-hk.github.io/catalyst-libs/branch/feat_signed_object/architecture/08_concepts/signed_doc/types/
enum SignedDocumentType {
  proposalDocument(uuid: '7808d2ba-d511-40af-84e8-c0d1625fdfdc'),
  proposalTemplate(uuid: '0ce8ab38-9258-4fbc-a62e-7faa6e58318f'),
  unknown(uuid: '');

  final String uuid;

  static String toJson(SignedDocumentType type) => type.uuid;

  static SignedDocumentType fromJson(String data) {
    return SignedDocumentType.values.firstWhere(
      (element) => element.uuid == data,
      orElse: () => SignedDocumentType.unknown,
    );
  }

  const SignedDocumentType({
    required this.uuid,
  });
}

final class SignedDocumentData extends Equatable {
  final SignedDocumentMetadata metadata;
  final SignedDocumentContent content;

  const SignedDocumentData({
    required this.metadata,
    required this.content,
  });

  @override
  List<Object?> get props => [
        metadata,
        content,
      ];
}

final class SignedDocumentMetadata extends Equatable {
  /// Type of this signed document
  final SignedDocumentType type;

  /// uuid-v7
  final String id;

  /// uuid-v7
  final String version;

  /// Reference to another document. The purpose of the ref will vary depending
  /// on the document type.
  final SignedDocumentRef? ref;

  /// This is a cryptographically secured reference to another document.
  final SecuredSignedDocumentRef? refHash;

  /// If the document was formed from a template, this is a reference to that
  /// template document
  final SignedDocumentRef? template;

  /// uuid-v4
  /// Represents a "brand" who is running the voting, e.g. Catalyst, Midnight.
  final String? brandId;

  /// uuid-v4
  /// Defines a "campaign" of voting, e.g. "treasury campaign".
  final String? campaignId;

  /// uuid-v4
  /// Defines an election, e.g. "Catalyst Fund 1", "Catalyst Fund 2".
  final String? electionId;

  /// uuid-v4
  /// Defines a voting category as a collection of proposals, e.g.
  /// "Development & Infrastructure",
  /// "Products & Integrations".
  final String? categoryId;

  const SignedDocumentMetadata({
    required this.type,
    required this.id,
    required this.version,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
        type,
        id,
        version,
        ref,
        refHash,
        template,
        brandId,
        campaignId,
        electionId,
        categoryId,
      ];
}
