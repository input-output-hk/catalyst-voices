import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Describes what [DocumentDataContent] is about. It only makes sens in
/// context of [type].
final class DocumentDataMetadata extends Equatable {
  /// Type of this signed document
  final DocumentType type;

  /// Reference to this document. Have to be exact.
  final DocumentRef selfRef;

  /// Reference to another document. The purpose of the ref will vary depending
  /// on the document type.
  final DocumentRef? ref;

  /// This is a cryptographically secured reference to another document.
  final SecuredDocumentRef? refHash;

  /// If the document was formed from a template, this is a reference to that
  /// template document
  final DocumentRef? template;

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
  final SignedDocumentRef? categoryId;

  /// List of String representation of CatalystId of users
  /// who are authors of this document
  final List<String> signers;

  DocumentDataMetadata({
    required this.type,
    required this.selfRef,
    this.ref,
    this.refHash,
    this.template,
    this.brandId,
    this.campaignId,
    this.electionId,
    this.categoryId,
    this.signers = const [],
  }) : assert(
          selfRef.isExact,
          'selfRef have to be exact. Make sure version is not null',
        );

  String get id => selfRef.id;

  @override
  List<Object?> get props => [
        type,
        selfRef,
        ref,
        refHash,
        template,
        brandId,
        campaignId,
        electionId,
        categoryId,
        signers,
      ];

  String get version => selfRef.version!;

  DocumentDataMetadata copyWith({
    DocumentType? type,
    DocumentRef? selfRef,
    Optional<DocumentRef>? ref,
    Optional<SecuredDocumentRef>? refHash,
    Optional<DocumentRef>? template,
    Optional<String>? brandId,
    Optional<String>? campaignId,
    Optional<String>? electionId,
    Optional<SignedDocumentRef>? categoryId,
    List<String>? signers,
  }) {
    return DocumentDataMetadata(
      type: type ?? this.type,
      selfRef: selfRef ?? this.selfRef,
      ref: ref.dataOr(this.ref),
      refHash: refHash.dataOr(this.refHash),
      template: template.dataOr(this.template),
      brandId: brandId.dataOr(this.brandId),
      campaignId: campaignId.dataOr(this.campaignId),
      electionId: electionId.dataOr(this.electionId),
      categoryId: categoryId.dataOr(this.categoryId),
      signers: signers ?? this.signers,
    );
  }
}
